Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762004Ab2FVKHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 06:07:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33253 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761977Ab2FVKHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 06:07:51 -0400
Date: Fri, 22 Jun 2012 11:07:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        dhowells@redhat.com, mszeredi@suse.cz
Subject: Re: [PATCH 00/21] vfs: atomic open v6 (part 2)
Message-ID: <20120622100747.GE14083@ZenIV.linux.org.uk>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
 <20120610034921.GB30000@ZenIV.linux.org.uk>
 <20120610111056.GD30000@ZenIV.linux.org.uk>
 <20120610175605.GE30000@ZenIV.linux.org.uk>
 <20120610222745.GG30000@ZenIV.linux.org.uk>
 <20120617203755.GA31478@infradead.org>
 <20120618115804.GA4048@infradead.org>
 <20120618131252.GA21931@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120618131252.GA21931@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 09:12:52AM -0400, Christoph Hellwig wrote:
> And here is fix number two, to be folded into the same commit:

Both folded.  FWIW, I'm not sure I'm happy about the reorg of failure
exits in follow_link() - gcc can't figure out that follow_link(..., &cookie)
can't return 0 without having passed through the assignment to cookie.
Hell knows; I still don't like the calling conventions in that one...
