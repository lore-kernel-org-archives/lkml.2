Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab2FJFy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 01:54:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56378 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2FJFy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 01:54:56 -0400
Date: Sun, 10 Jun 2012 06:54:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz
Subject: Re: [PATCH 00/21] vfs: atomic open v6 (part 2)
Message-ID: <20120610055452.GC30000@ZenIV.linux.org.uk>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
 <20120610034921.GB30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120610034921.GB30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	BTW, I realize that right now you are relying on -EOPENSTALE
never coming out of ->atomic_open(), but that needs to be documented.
For now I'm adding BUG_ON() there as a crude way of documenting it;
AFAICS, there's no point whatsoever doing retries in that case.
