Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1HJLDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 07:03:36 -0400
Received: from vm4.telegraphics.com.au ([98.124.60.149]:51673 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1HJLDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 07:03:35 -0400
X-Greylist: delayed 1026 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Aug 2011 07:03:35 EDT
Date: Wed, 10 Aug 2011 20:48:27 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: Convert to genirq (WIP)
In-Reply-To: <CAMuHMdWcB2JmfxPz=bs3TM2eTPYWnzjFeXw0PRXTTcPeHBQPPQ@mail.gmail.com>
Message-ID: <alpine.OSX.2.00.1108102047150.203@ibook.local>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg> <BANLkTimebx56-Wb5JPWxYVnND9gG8OVdsQ@mail.gmail.com> <BANLkTin+gp2Cnxj8kHbHRmuoEgyDR8YeaQ@mail.gmail.com> <BANLkTik5-H1fc2rk3QrwvQiF=7fELmE2CA@mail.gmail.com> <alpine.OSX.2.00.1106171337170.191@ibook.intranet>
 <CAMuHMdWcB2JmfxPz=bs3TM2eTPYWnzjFeXw0PRXTTcPeHBQPPQ@mail.gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-91237281-1312973307=:203"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-91237281-1312973307=:203
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Mon, 8 Aug 2011, Geert Uytterhoeven wrote:

> I did some more refactoring which made the Mac conversion trivial (but
> still untested).
> I'll prepare it for publishing when the kids leave me alone ;-)

I'd be happy to test it.

Finn

>=20
> Gr{oetje,eeting}s,
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert
--0-91237281-1312973307=:203--
