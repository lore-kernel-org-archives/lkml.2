Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab1CHUSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:18:11 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:39185 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab1CHUSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:18:07 -0500
Date: Tue, 8 Mar 2011 21:17:29 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Milan Broz <mbroz@redhat.com>
Cc: dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-crypt] dm-crypt: Performance Regression 2.6.37 ->
 2.6.38-rc8
Message-ID: <20110308201729.GB8356@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Milan Broz <mbroz@redhat.com>, dm-crypt@saout.de,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
	Alasdair G Kergon <agk@redhat.com>
References: <20110308164508.GA8729@darkside.kls.lan>
 <4D7668C5.5050100@redhat.com>
 <20110308192341.GA8356@darkside.kls.lan>
 <4D768C6E.6010202@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
In-Reply-To: <4D768C6E.6010202@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 08, 2011 at 09:07:10PM +0100, Milan Broz wrote:
> Could you please try also writes? I get better results than reads here.

No, I can't, sorry. I don't have *that* spare devices to try with.
However, if you are able to reproduce my read-results your write-results
should be similar to what I'd get.


Mario
--=20
The secret that the NSA could read the Iranian secrets was more
important than any specific Iranian secrets that the NSA could
read.                           -- Bruce Schneier

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUBTXaO2RS+e2HeSPbpAQK39Af/ZpGIvLn3CRIrHf5uqOjkDg8iDUqGE5Jg
6nNEBENNEk7/J7W4fOTgfi9En2TgqxpdJmOcI/+oJPNBZMpI5OBgaw6aey6Hcds9
eeT1MGAH0XyVw0ZYbtRIy5gyLnHMIf27Ip24W4Jz2DevMcJ68T1fuEhVWB/h/d5B
zxtuiXRP/FpCSti+owK9if2pKzPN8d3ZDiveeY+v3/703iDAAhQSTH1xw5OKT0HQ
25tTUjyUiSvQoQUJopFMhz2hasYtvF7LrzOEtujdtVC+7eyPXhYmkV15wNIcxE9y
7tl2ZvIH6ytzm7m0wEGVse5m90onWUC96PRklo/zIXnz2ORffhI4aQ==
=6CDx
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
