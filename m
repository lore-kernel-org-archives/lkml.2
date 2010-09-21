Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0IUFZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 01:25:13 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:43749 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab0IUFZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 01:25:11 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Sep 2010 01:25:11 EDT
Date: Tue, 21 Sep 2010 15:17:46 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Matt Turner <mattst88@gmail.com>
cc: "Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Ben Pfaff <blp@cs.stanford.edu>, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH]Update-broken-web-addresses-in-the-kernel
In-Reply-To: <AANLkTimYp6ua743x9ze4fcU09ZZ=oZZd_iKCmU0WQ2h7@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1009211516180.9370@nippy.intranet>
References: <1285042724-19135-1-git-send-email-justinmattock@gmail.com> <AANLkTinE73z9QV0zriVE3bRtzMifWSGvG36hfvnA9biD@mail.gmail.com> <4C983C7D.1050000@gmail.com> <AANLkTimYp6ua743x9ze4fcU09ZZ=oZZd_iKCmU0WQ2h7@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463806400-1593740976-1285046266=:9370"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463806400-1593740976-1285046266=:9370
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE


I would say that if a URL is in the web archive, then no patch is needed.

Finn

On Tue, 21 Sep 2010, Matt Turner wrote:

> On Tue, Sep 21, 2010 at 1:02 AM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
> > didnt even think about that.. I really appreciate you pointing this out=
=2E.
> > =A0I'll go through the whole thing and see if I can figure a good fix f=
or the
> > archive.org stuff
>=20
> Just checked, and you can modify the links like so:
>=20
> - http://web.archive.org/web/*/http://ftp.digital.com/pub/DEC/axppci/ref_=
interrupts.txt
> + http://web.archive.org/web/%2A/http://ftp.digital.com/pub/DEC/axppci/re=
f_interrupts.txt
>=20
> So, change * to %2A (it's ASCII code in hex).
>=20
> I guess that's the least clunky fix.
>=20
> Matt
>=20
---1463806400-1593740976-1285046266=:9370--
