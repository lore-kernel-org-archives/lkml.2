Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab0KGM55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 07:57:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab0KGM54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 07:57:56 -0500
Date: Sun, 7 Nov 2010 13:57:46 +0100
From: Jan Kara <jack@suse.cz>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jens.axboe@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        gregkh@suse.de
Subject: Re: Sync writeback still broken
Message-ID: <20101107125746.GA5126@quack.suse.cz>
References: <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
 <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr>
 <20100215144938.GD3434@quack.suse.cz>
 <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr>
 <alpine.LSU.2.01.1006271842220.1495@obet.zrqbmnf.qr>
 <alpine.LNX.2.01.1010250115360.16022@obet.zrqbmnf.qr>
 <20101031122437.GA6296@quack.suse.cz>
 <20101031224012.GB13207@quack.suse.cz>
 <20101105213324.GA25520@quack.suse.cz>
 <alpine.LNX.2.01.1011052302400.17206@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1011052302400.17206@obet.zrqbmnf.qr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 05-11-10 23:03:31, Jan Engelhardt wrote:
> 
> On Friday 2010-11-05 22:33, Jan Kara wrote:
> >  OK, so at Kernel Summit we agreed to fix the issue as I originally wanted
> >by patches
> >http://marc.info/?l=linux-fsdevel&m=128861735213143&w=2
> >and
> >http://marc.info/?l=linux-fsdevel&m=128861734813131&w=2
> >
> >  I needed one more patch to resolve the issue (attached) which I've just
> >posted for review and possible inclusion.
> 
> If you have a branch that has all three and is easy to fetch, I'll
> get on it right away.
  In my repo:
git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git
  I've created branch writeback_fixes which has 2.6.37-rc1 + the three
patches.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
