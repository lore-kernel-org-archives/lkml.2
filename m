Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab1JNQGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:06:55 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:49955 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753814Ab1JNQGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:06:54 -0400
Date: Fri, 14 Oct 2011 09:06:46 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, resend] x86: constify PCI raw ops structures
Message-ID: <20111014090646.06aef304@jbarnes-desktop>
In-Reply-To: <4E71CC5B020000780005636B@nat28.tlf.novell.com>
References: <4E71CC5B020000780005636B@nat28.tlf.novell.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/j6BDPFkYQu1B4w=lCskeh2B"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/j6BDPFkYQu1B4w=lCskeh2B
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Sep 2011 08:58:51 +0100
"Jan Beulich" <JBeulich@suse.com> wrote:

> As with any other such change, the goal is to prevent inadvertent
> writes to these structures (assuming DEBUG_RODATA is enabled), and to
> separate data (possibly frequently) written to from such never getting
> modified.
>=20
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Yay finally got this one applied to linux-next, thanks Jan!

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/j6BDPFkYQu1B4w=lCskeh2B
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOmF4WAAoJEIEoDkX4Qk9h+k0QAMGTrAWmuL6ovK5/oVW93Mqn
yAzCToiKOe33Od1nfsx+ji49JmkA29U9VEpu5VqAOea/auN6LCNyP7F0NZbUt4G4
x7v5iJlHmzp8W5gEsOHzgwWkL3Dycl41jMdSOjfU1w2eH7B9vRLLtZjF1TJTpiBI
bRcjTRmPCC7+0roaJ58y6yjrVlGz2YfnOyKgs28hYIglTUMMFLPaetfeua3ZVBU+
uWzMxJYnrm3/47xfDabfaCLnjZ+T+w7g23XgbsT5YUR3o0yIDMcLPB/NwjOzs9w5
FpWD6DAuge2wywCEoN+kW6veV8hwnRWfRzH4khQcgqkcC+qUw4V0ULoINnG02OLC
NMITtxzKhB7k5bHVUIJsQZ2iuvL08rpnGdJrNYzuhJir2U4Q5Vx0gEjKdnsnrHNR
uyS+cNj8kkI+1Nz3SQgr7Bq1LwSk5ljf/VivhYVW115A/nAkMOEjPcRfJ7VcJj+2
I6Bf/JGx3bef2lQGKAEZlIpIvLvnyX5FrsdoRyjjy26AEzGltODfTIFsl03bjHgA
V3BxBxnW45GeskKQjg2emheyO/ZNsfEOyCCEhTJrBa/83DyRQU0Oo4wPw1llNlkN
KYTFt+O1r4ydenbOewnNOBfjerFcwPD21/66RUWHp9BSAX1WNqhMXvcfN77gP5fR
4xO1tNBJvu0TEGsMt4IQ
=GMTw
-----END PGP SIGNATURE-----

--Sig_/j6BDPFkYQu1B4w=lCskeh2B--
