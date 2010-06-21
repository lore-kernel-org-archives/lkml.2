Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab0FUWpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:45:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35353 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab0FUWpM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:45:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
Date: Tue, 22 Jun 2010 00:43:46 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera> <rHrHQMIU4rI.A.5FD.vepHMB@chimera> <201006220019.34874.s.L-H@gmx.de>
In-Reply-To: <201006220019.34874.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006220043.46459.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Tuesday 22 June 2010, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.33 and 2.6.34.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15589
> > Subject		: 2.6.34-rc1: Badness at fs/proc/generic.c:316
> > Submitter	: Christian Kujau <lists@nerdbynature.de>
> > Date		: 2010-03-13 23:53 (100 days old)
> > Message-ID	: < <AANLkTikNcCtUn9SQwKu2b3IE6NiAwAhciHsm1HVH4EJh@mail.gmail.com>>
> > References	: http://marc.info/?l=linux-kernel&m=126852442903680&w=2
> > Handled-By	: Michael Ellerman <michael@ellerman.id.au>
> > 		  Jindøich Makovièka <makovick@gmail.com>
> > Patch		: http://patchwork.ozlabs.org/patch/52978/
> > 		  http://lkml.indiana.edu/hypermail/linux/kernel/1006.0/00137.html
> 
> At least the effects on b2c2-flexcop-pci are still valid, in linux-2.6
> HEAD and linux-next (next-20100621).

Thanks for the update.

Rafael
