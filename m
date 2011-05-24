Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031142Ab1EXBYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:24:32 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59267 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031108Ab1EXBY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:24:29 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Mike Frysinger <vapier@gentoo.org>
Cc: Joe Perches <joe@perches.com>, anish singh <anish198519851985@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, davej@redhat.com,
        rostedt@goodmis.org, apw@shadowen.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
Subject: Re: [patch v3] checkpatch: Signature format verification
In-Reply-To: Your message of "Mon, 23 May 2011 18:51:42 EDT."
             <BANLkTimCZP0raacMazU7wWTtoAUcUE9vRQ@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1306006721.1622.18.camel@anish-desktop> <1306059528.2761.3.camel@anish-desktop> <1306164094.2292.25.camel@anish-desktop> <1306167105.8687.11.camel@Joe-Laptop> <BANLkTi=9nzMbxU0=P+pOaHcebqhL=bd2HQ@mail.gmail.com> <1306168598.8687.27.camel@Joe-Laptop> <20110523093920.8f1e5cd0.rdunlap@xenotime.net> <1306168975.8687.29.camel@Joe-Laptop> <BANLkTik8coVxt=Z92NQBNH_=4yRhTtexzA@mail.gmail.com> <1306171117.8687.34.camel@Joe-Laptop> <BANLkTikqezyJMy1_i-woTVM9bvVL750iew@mail.gmail.com> <1306174166.8687.49.camel@Joe-Laptop>
            <BANLkTimCZP0raacMazU7wWTtoAUcUE9vRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306200244_3286P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 23 May 2011 21:24:04 -0400
Message-ID: <5210.1306200244@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4DDB08B9.0078,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306200244_3286P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 23 May 2011 18:51:42 EDT, Mike Frysinger said:
> On Mon, May 23, 2011 at 14:09, Joe Perches wrote:
> > =A0 =A0167 =A0 =A0 Signed-off-by: =22Theodore Ts'o=22 <tytso=40mit.ed=
u>
>=20
> personally, i dont think those quotes should be there

Although not strictly required by the ABNF of RFC822 and its successors, =
it's
probably a wise thing to apply the double quotes in this case anyhow, due=
 to
the fairly high likelyhood that some software will choke on the ' charact=
er in
Ted's last name if unquoted.


--==_Exmh_1306200244_3286P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN2wizcC3lWbTT17ARAlRRAKClQXfN/9rCc+i88mWhDEwzPiil+gCeJTeN
s/IpQcrmQPwxZcTzUBDPSWo=
=iF7k
-----END PGP SIGNATURE-----

--==_Exmh_1306200244_3286P--

