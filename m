Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab1FQDo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 23:44:58 -0400
Received: from vm4.telegraphics.com.au ([98.124.60.149]:59326 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab1FQDo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 23:44:57 -0400
Date: Fri, 17 Jun 2011 13:45:24 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: Convert to genirq (WIP)
In-Reply-To: <BANLkTik5-H1fc2rk3QrwvQiF=7fELmE2CA@mail.gmail.com>
Message-ID: <alpine.OSX.2.00.1106171337170.191@ibook.intranet>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg> <BANLkTimebx56-Wb5JPWxYVnND9gG8OVdsQ@mail.gmail.com> <BANLkTin+gp2Cnxj8kHbHRmuoEgyDR8YeaQ@mail.gmail.com> <BANLkTik5-H1fc2rk3QrwvQiF=7fELmE2CA@mail.gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-915750856-1308282324=:191"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-915750856-1308282324=:191
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Thu, 16 Jun 2011, Geert Uytterhoeven wrote:

> On Wed, Jun 15, 2011 at 21:44, Geert Uytterhoeven <geert@linux-m68k.org> =
wrote:
> > On Sat, Jun 4, 2011 at 19:56, Geert Uytterhoeven <geert@linux-m68k.org>=
 wrote:
> >> On Sat, May 28, 2011 at 20:32, Geert Uytterhoeven <geert@linux-m68k.or=
g> wrote:
> >>
> >> It works on Amiga now, too. It can still use some optimizations in=20
> >> the irq_{enable,disable,ack,mask,mask_ack,unmask} area, as my=20
> >> BogoMIPS rating dropped by ca 2.5% and is now under 16, for a 25 MHz=
=20
> >> 68040.
> >
> > Seems like everything (Atari/ARAnyM and Amiga) still works when using=
=20
> > handle_simple_irq instead of handle_level_irq. As a bonus, BogoMIPS is=
=20
> > above 16 again.

Your bogomips benchmark would be the best-case penalty, right?

Have you tried say, sending a ping flood to measure throughput and=20
latency?

>=20
> With handle_simple_irq(), we no longer need to define irq_{,un}mask()=20
> methods in our irq_chips. Hence the "old" m68k platform interrupt code=20
> seems to be much closer to genirq than I thought...
>=20
> Does this make sense?

If the simple irq model gets us closer to the goal and doesn't kill=20
performance then it makes sense to me.

Finn

>=20
> Gr{oetje,eeting}s,
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert
>=20
--0-915750856-1308282324=:191--
