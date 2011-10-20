Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1JTXbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 19:31:11 -0400
Received: from vm4.telegraphics.com.au ([98.124.60.149]:40374 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab1JTXbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 19:31:09 -0400
Date: Fri, 21 Oct 2011 10:30:58 +1100 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/28 v6] m68k: Convert to genirq
In-Reply-To: <CAMuHMdW7x1_6P6UiaiHf-ynvsGjX76eZtw4PU2SvberKGD69hg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1110211026230.2344@nippy.intranet>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org> <CAMuHMdWOhKcoDoyTnKJzruZ=gpV5uKNFpXnGCkrac7oEkCihJw@mail.gmail.com> <alpine.LNX.2.00.1110202347320.2696@nippy.intranet> <CAMuHMdVMp65XzV2zu7V8sgwsniCAxD7NDDnHSvp5gO-8g1ovHg@mail.gmail.com>
 <CAMuHMdW7x1_6P6UiaiHf-ynvsGjX76eZtw4PU2SvberKGD69hg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463806400-1436577219-1319153458=:2344"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463806400-1436577219-1319153458=:2344
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Thu, 20 Oct 2011, Geert Uytterhoeven wrote:

> On Thu, Oct 20, 2011 at 17:02, Geert Uytterhoeven <geert@linux-m68k.org> =
wrote:
> > On Thu, Oct 20, 2011 at 15:40, Finn Thain <fthain@telegraphics.com.au> =
wrote:
> >> Sounds good. The mac_esp fix I sent is already in linux-next.
> >
> > Thanks for reminding me I still have to apply that one :-)
>=20
> That's e544d704f9bea6892808e453e219aa305bc0269a
> ("[SCSI] mac_esp: remove redundant mutual exclusion")?

Yes.

> And it should be applied (at least to m68k/master)_before_ the genirq
> conversion, right?

For bisection purposes, yes.

Finn

>=20
> Gr{oetje,eeting}s,
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert
>=20
---1463806400-1436577219-1319153458=:2344--
