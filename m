Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab1EaIXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:23:01 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:39144 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758078Ab1EaIW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:22:58 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: "D. Jansen" <d.g.jansen@googlemail.com>
Cc: david@lang.hm, Theodore Tso <tytso@mit.edu>,
        Oliver Neukum <oneukum@suse.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        njs@pobox.com, bart@samwel.tk
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
In-Reply-To: Your message of "Mon, 30 May 2011 23:24:03 +0200."
             <BANLkTimSLoY3uwtGvA2x5C0HhNEHvmWqzw@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard> <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com> <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu> <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com> <20110526133155.GH9520@thunk.org> <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com> <20110526162138.GN9520@thunk.org> <BANLkTinPCcX9-gK7YnMngGUJKftRTmYXNw@mail.gmail.com> <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com> <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com> <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm> <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com> <alpine.DEB.2.02.1105301142030.5766@asgard.lang.hm> <BANLkTimuToT90eRGVRfN9tAHoF9GOSRRDA@mail.gmail.com> <alpine.DEB.2.02.1105301349530.5766@asgard.lang.hm>
            <BANLkTimSLoY3uwtGvA2x5C0HhNEHvmWqzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306830145_2772P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 31 May 2011 04:22:25 -0400
Message-ID: <20211.1306830145@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4DE4A546.0098,ss=1,fgs=0,
	ip=71.62.120.129,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306830145_2772P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 30 May 2011 23:24:03 +0200, =22D. Jansen=22 said:

> > do you really have so many fsync's going on that the disk spins up so=
 much
> > that you would gain 10-20% battery life?
>=20
> Yes. Every autosave in LibreOffice triggers one. And I want autosave,
> but I want them in memory, not on disk.

I think what you want from autosave isn't what the LibreOffice team wants=

from autosave.  Remember, if they're in memory, they aren't *really* save=
d.

--==_Exmh_1306830145_2772P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN5KVBcC3lWbTT17ARAuEMAKCiuITwQT7aZZUlPGGEsOkL20MR8ACfV2mK
2co3Kt+bJ6jsBfOtf2woJtw=
=z+cb
-----END PGP SIGNATURE-----

--==_Exmh_1306830145_2772P--

