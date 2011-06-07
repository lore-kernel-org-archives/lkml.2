Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab1FGP0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:26:54 -0400
Received: from comu.ring0.de ([46.4.151.82]:34115 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab1FGP0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:26:53 -0400
X-Greylist: delayed 1053 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jun 2011 11:26:52 EDT
X-Spam-Report: * -2.6 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.1 AWL AWL: From: address is in the auto white-list
Date: Tue, 7 Jun 2011 17:09:10 +0200
From: Sebastian Reichel <sre@debian.org>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: ext Linus Walleij <linus.walleij@linaro.org>,
        Govindraj <govindraj.ti@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        pawel.szyszuk@stericsson.com
Subject: Re: [RFC PATCHv4 0/7] HSI framework and drivers
Message-ID: <20110607150910.GA3780@earth.universe>
References: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
 <AANLkTimTfOyhDR6BsHD_1VvzOPGbYqo6L784wPkQMi_8@mail.gmail.com>
 <1300787404.8008.116.camel@groo>
 <BANLkTincpt8ojK8icvXz4XfkWL9z87VmUA@mail.gmail.com>
 <BANLkTikrXb7h_iG+xOvFPozT6w5Nj8nJKw@mail.gmail.com>
 <1305621553.24348.5009.camel@groo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <1305621553.24348.5009.camel@groo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 17, 2011 at 11:39:13AM +0300, Carlos Chinea wrote:
> We are still committed to these patches. We are aiming to release a new
> version in 3 weeks max, sooner if we can.
>=20
> I am very sorry for the delay and I agree that starting to have several
> out-of-tree drivers is not acceptable. I'll try my best to fix this
> asap.

Do you also plan to add the platform code for rx51 to the mainline
kernel?

P.S.: 3 weeks are over today :)

-- Sebastian

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJN7j8WAAoJENju1/PIO/qa/3MP/iWMCzyefZ+owutnptxNaUet
9iKGI71//7VFCsIJofAq4zIpWTBvXI+/mjQmvS/ciI9qspL0/2aRIg9dfFkDdQk/
L8d8KkeYFz8Nu7Hrh9DHG5f2Dkqti6FRUFrRY4e5xKQ8IaVcg9BXTcsU0pUC0F+O
Y2IAVkCkjAWGPFn7kwj9hvzg3MfztMRo9zGemfXv4tqevd8mhNDJttZjdJuoiaWT
O+F3tvMDFlv/fZBHI5su+E2rcZXxqh4XU8cw4+osDXEmVulPshMMtN6+Ywj14IHG
sy89c9jI5jYQpWDyynGYpu7N1CZby56eYH0Xl3tHixdn+PGI5e2+IIy0FukqXiMl
eoPZC2IzgnC+Pl2LehGpNC4nzXSwaO/AkxBUA4jE+DF46cyo74/qdWm+8wb6p2VX
Asb6QwXXJ/XwibI019a1thkMtn/VhoiEdNWII3bKYuJQQEz86BCKD/vOKj81FG09
+9yTHnnUGF2T0hI/lK2hTtheFWA3fpLb3umM473YZbTb5l+vLbFzKltC0joDs7mr
cf1MC8lqVmkQ5eUsef6i448OtrQFAs/62I8yHmoBSUStE35I/gAA8BAdLv/EZELA
FDSUv9kZ+mytHypVsXhQ42XyaUYBt0oLs4d4Mio9gdPqZYF1CMy0qYKpOFSFkuDm
8VJbr4LhfznME3vQV5Xh
=UNag
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
