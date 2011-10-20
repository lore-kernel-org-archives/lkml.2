Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab1JTNk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:40:28 -0400
Received: from vm4.telegraphics.com.au ([98.124.60.149]:58641 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1JTNk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:40:27 -0400
Date: Fri, 21 Oct 2011 00:40:17 +1100 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 00/28 v6] m68k: Convert to genirq
In-Reply-To: <CAMuHMdWOhKcoDoyTnKJzruZ=gpV5uKNFpXnGCkrac7oEkCihJw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1110202347320.2696@nippy.intranet>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org> <CAMuHMdWOhKcoDoyTnKJzruZ=gpV5uKNFpXnGCkrac7oEkCihJw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463806400-1776993008-1319115337=:2696"
Content-ID: <alpine.LNX.2.00.1110210001350.2696@nippy.intranet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463806400-1776993008-1319115337=:2696
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.LNX.2.00.1110210001351.2696@nippy.intranet>


On Thu, 20 Oct 2011, Geert Uytterhoeven wrote:

> > There are some known issues with drivers, which Finn and Michael are=20
> > looking into.
>=20
> Any fixes I still have to apply?

I did some further testing on Baboon and OSS hardware etc. and I didn't=20
find any new regressions to fix.

There is a cleanup patch though --=20
http://article.gmane.org/gmane.linux.ports.m68k/2726

> Updated, on top of m68k master (which is at v3.1-rc10 now).
> http://git.kernel.org/?p=3Dlinux/kernel/git/geert/linux-m68k.git;a=3Dshor=
tlog;h=3Drefs/heads/m68k-genirq
>=20
> If noone objects, I'd like to add this to the m68k master and for-3.2=20
> branches.

Sounds good. The mac_esp fix I sent is already in linux-next.

Finn

>=20
> Gr{oetje,eeting}s,
>=20
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Geert
---1463806400-1776993008-1319115337=:2696--
