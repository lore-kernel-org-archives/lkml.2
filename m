Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0GJN4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 09:56:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43446 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab0GJN4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 09:56:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gULlC2VMubXmBWxNNUO54cb7nHi8ucwrgQXFAjRd9iGku+ispvfj4QEVLsoBqQp4WU
         m8iDTcetYyGtvo9cAJIWT4xS4GDXiqzb218NEMPZLyHyD3XDdJKN8kRa59ScGbllSMGj
         GsRrpSizcnYhO5fTJgTnHIZxver05fGduh690=
Date: Sat, 10 Jul 2010 15:56:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [Bug #15805] reiserfs locking
Message-ID: <20100710135606.GB5306@nowhere>
References: <xkNyyYrLiTN.A.s_G.7p7NMB@chimera> <Hc02ROPrUsG.A.vs.ls7NMB@chimera> <20100710014504.GC5269@nowhere> <20100710070650.GA16248@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100710070650.GA16248@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 09:06:50AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Sat, Jul 10, 2010 at 02:33:24AM +0200, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.33 and 2.6.34.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> > > be listed and let the tracking team know (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15805
> > > Subject		: reiserfs locking
> > > Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> > > Date		: 2010-04-15 21:02 (86 days old)
> > > Message-ID	: <t2ka4423d671004151402n7b2dc425mdc9c6bb9640d63fb@mail.gmail.com>
> > > References	: http://marc.info/?l=linux-kernel&m=127136535323933&w=2
> > > Handled-By	: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > 
> > It's a duplicate of 16334. Or rather 16334 is a duplicate of this
> > but the discussion about the issue was more developped in 16334.
> > 
> > Anyway this is not a regression (at least not recent) and the fix
> > from Al is in the vfs tree in the for-next branch on commit
> > 6c2bdaf089a3876226893fab00dd83596c465ad2
> > "Fix reiserfs_file_release()"
> 
> Since it's a reproducible deadlock maybe the fix should go upstream faster 
> than v2.6.36?
> 
> Thanks,
> 
> 	Ingo


May be yeah. Although the fix is not a naive trick and it changes a sensitive
piece of code.

Don't know what Al has planned with it.

