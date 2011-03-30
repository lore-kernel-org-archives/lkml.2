Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab1C3Ict (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 04:32:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:52909 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682Ab1C3Icr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 04:32:47 -0400
Date: Wed, 30 Mar 2011 10:32:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Frysinger <vapier@gentoo.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [patch 0/2] blackfin: Final irq cleanup
In-Reply-To: <AANLkTi=Ou2Vr1fa5yzmdJTGahMB=UUf4sUufh8AWrz21@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1103301023560.22418@localhost6.localdomain6>
References: <20110325133039.521553268@linutronix.de> <AANLkTi=AOXL==fgOwsY9ujFehYnsUFAQrvLy1CLwFEhu@mail.gmail.com> <AANLkTi=Ou2Vr1fa5yzmdJTGahMB=UUf4sUufh8AWrz21@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1248423545-1301473966=:22418"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1248423545-1301473966=:22418
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 30 Mar 2011, Mike Frysinger wrote:

> On Fri, Mar 25, 2011 at 17:17, Mike Frysinger wrote:
> > On Fri, Mar 25, 2011 at 09:32, Thomas Gleixner wrote:
> >> this is the final cleanup and name space conversion, so that we can
> >> remove the deprecated code in the core.
> >>
> >> It would be nice to get this Linus wards for .39
> >
> > does this require some other patch ?  a recent merge from another tree
> > broke Blackfin, so i need to push out stuff to Linus again anyways.
> 
> hmm, so i guess you just merged this through your own tree ?

Yeah, we wanted to get rid of the core cruft, so we put all the
pending stuff in.

Thanks,

	tglx
---1463795968-1248423545-1301473966=:22418--
