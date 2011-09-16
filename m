Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1IPRDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:03:34 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54683 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1IPRDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:03:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Russell King <rmk+alsa@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>, Harald Welte <laforge@openezx.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [linux-next] ASoC: sound/soc/samsung/neo1973_wm8753.c build failure
In-Reply-To: Your message of "Thu, 15 Sep 2011 13:53:04 +0200."
             <4E71E720.7040008@metafoo.de>
From: Valdis.Kletnieks@vt.edu
References: <1315991893.17271.2.camel@phoenix> <20110914191917.GA30518@flint.arm.linux.org.uk> <20110914232808.GC2953@opensource.wolfsonmicro.com> <20110914233838.GB22946@flint.arm.linux.org.uk> <20110915094640.GA7988@opensource.wolfsonmicro.com> <20110915110056.GA32615@flint.arm.linux.org.uk>
            <4E71E720.7040008@metafoo.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316192529_55056P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 16 Sep 2011 13:02:09 -0400
Message-ID: <56969.1316192529@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A010206.4E738115.0085,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316192529_55056P
Content-Type: text/plain; charset=us-ascii

On Thu, 15 Sep 2011 13:53:04 +0200, Lars-Peter Clausen said:
> On 09/15/2011 01:00 PM, Russell King wrote:
> > [...]
> > We now have a sane policy: entries which aren't fully up to date are
> > automatically dropped.  Entries for which there is no platform support
> > file merged within 12 months of the entries last edit are dropped also
> > automatically dropped.
> 
> Partly unrelated, but what about these platforms which can be fully described
> with DT and don't need a platform file?

Then those platforms won't notice if their now-unused entries evaporate out of
the platform file, right?

--==_Exmh_1316192529_55056P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOc4ERcC3lWbTT17ARAmjWAJwIcfH9HqMH9fpYfHq20Q7oyapV1QCcDMic
mdI3buT+ZL199AOtx8JWznE=
=/Nsl
-----END PGP SIGNATURE-----

--==_Exmh_1316192529_55056P--

