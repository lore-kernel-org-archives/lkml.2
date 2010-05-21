Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934166Ab0EUTZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 15:25:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:53935 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab0EUTZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 15:25:05 -0400
Date: Fri, 21 May 2010 21:24:56 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PULL REQUEST] Ext2, ext3, and quota updates for 2.6.35-rc1
Message-ID: <20100521192456.GE10149@quack.suse.cz>
References: <20100521174658.GA10149@quack.suse.cz>
 <20100521184428.GC10149@quack.suse.cz>
 <alpine.LFD.2.00.1005211146160.3689@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005211146160.3689@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 21-05-10 11:50:15, Linus Torvalds wrote:
> 
> 
> On Fri, 21 May 2010, Jan Kara wrote:
> >
> >   Oops, I've just found a bug in one of my ocfs2 fixes. I've fixed that up
> > so the new diffstat is here:
> 
> I already pulled your previous version.
  OK, I'll push the fix separately.

> And btw, Jan, I'm getting pretty upset with your apparently cavalier 
> attitude to filesystems. We've had several bugs lately for some quota or 
> filesystem "cleanups", which in at least one case caused corrupted 
> filesystems etc.
  That ext3 bug was nasty I agree :( I'm now pushing some quota tests to
XFSQA and setup a machine that runs them. So that should improve a test
coverage...

> You need to be a hell of a lot more careful, or I will have to stop 
> pulling from you. Filesystem bugs are _major_ no-no's. 
> 
> How long had that buggy commit been tested? By who? Was it acked or 
> reviewed by anybody else?
  The buggy commit was "ocfs2: Fix lock inversion in quotas during umount"
and it was reviewed by Joel Becker. Neither of us realized that we have to
stop quota syncing thread also on remount read-only...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
