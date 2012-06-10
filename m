Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2FJR4N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 13:56:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60000 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab2FJR4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 13:56:12 -0400
Date: Sun, 10 Jun 2012 18:56:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz
Subject: Re: [PATCH 00/21] vfs: atomic open v6 (part 2)
Message-ID: <20120610175605.GE30000@ZenIV.linux.org.uk>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
 <20120610034921.GB30000@ZenIV.linux.org.uk>
 <20120610111056.GD30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120610111056.GD30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 12:10:56PM +0100, Al Viro wrote:

> WARNING: I haven't even tried to boot it.  It builds, but this is all I can
> promise at the moment.  I'm about to fall down (it's 7am here already ;-/),
> will give it some beating when I get up.  It almost certainly has bugs, so
> consider that as call for review and not much more.

OK, it boots, mounts NFS and even manages to build a kernel on it.  Which
probably would meet Linus' "it's perfect, ship it" criteria, so go ahead
and beat it up, folks.
