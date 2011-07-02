Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1GBTyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 15:54:17 -0400
Received: from ist.d-labs.de ([213.239.218.44]:48759 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab1GBTyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 15:54:16 -0400
Date: Sat, 2 Jul 2011 21:54:12 +0200
From: Florian Mickler <florian@mickler.org>
To: Shawn Starr <shawn.starr@rogers.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #37232] [3.0-rc1][NMI/DMAR][iwlagn] errors - PCI system
 error (SERR) for reason a1 on CPU 0
Message-ID: <20110702215412.00527491@schatten.dmk.lab>
In-Reply-To: <4678134.li9aFGSxuF@segfault.sh0n.net>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera>
	<2202361.0SXGgnGr4r@segfault.sh0n.net>
	<201106292132.12265.rjw@sisk.pl>
	<4678134.li9aFGSxuF@segfault.sh0n.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011 23:57:57 -0400
Shawn Starr <shawn.starr@rogers.com> wrote:

> >>>On Wednesday, June 29, 2011 09:32:12 PM Rafael J. Wysocki wrote:
> > > On Sunday, June 26, 2011 11:23:44 PM Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a summary
> > > report of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.39.  Please verify if it still should be listed and let the
> > > tracking team know (either way).
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37232
> > > Subject		: [3.0-rc1][NMI/DMAR][iwlagn] errors - PCI system error (SERR) for reason a1 on CPU 0
> > > Submitter	: Shawn Starr <XXXX.XX@rogers.com>
> > > Date		     : 2011-06-03 4:56 (24 days old)
> > > Message-ID: <4478124.OuFNgaPiHS@segfault.sh0n.net>
> > > References	: http://marc.info/?l=linux-kernel&m=130707737616116&w=2
> 
> >>> Thanks for the update.
> >>> Rafael
> 
> Hello Rafael/Linux devs,
> 
> You can close this bug now, regression is gone now. Both the SERR and the DMAR  (coming from iwlagn)
> errors are resolved.
> 
> Working in: -rc5 (Fedora rawhide 3.0-0.rc5.git0.1.fc16.x86_64)
> 

Is this a vanilla linux kernel or has it out of tree patches?

> Thanks,
> Shawn.
