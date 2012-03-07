Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805Ab2CGTVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:21:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42091 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758174Ab2CGTVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:21:40 -0500
Date: Wed, 7 Mar 2012 19:21:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Silence error message in max8998_pmic_probe
Message-ID: <20120307192138.GB3107@opensource.wolfsonmicro.com>
References: <1331104540.7801.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mZSo2Zk6iB5ZAp9g"
Content-Disposition: inline
In-Reply-To: <1331104540.7801.2.camel@phoenix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mZSo2Zk6iB5ZAp9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 07, 2012 at 03:15:40PM +0800, Axel Lin wrote:
> This looks like a mistakenly committed debug logging.

Applied, thanks.

--mZSo2Zk6iB5ZAp9g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPV7U7AAoJEBus8iNuMP3dHfYQAIeML8droOY6AMk2tjUxnBkn
FEIh+7yykrkPXjEdZoJXY3s4Azx114L3JgAs92DmtltwkYWjmvT1pob2Qj23OjkB
SBuicEqwJFMIIOFkpr+9wjf0TNGE792zfTd2xeWun5a8ap1nbgIA47HmqSUnih1p
nu9Ise9dvSf5gCRQ9nHJiiMrb2GiU5II+YPytomh/P1UbeZNgWi0mWfKNWVRUg5e
oPVdq8Tqmbz/Kcuj6MLFjy6LjF6LMGXXgG4wEDdfN/kVsQlpQ7/wzuzVP5efMR99
d12s11+gKp4HShMjRbI+nQkFth89agfVxoG0S7thZzokSnSCHApCA83eovuNthD0
ULWa02lCxzqno7pdjekKDBIcc4cJS2UP2iI0WQ2Wr/CMz/7ZnaB8Qc92hMn7AufM
e8WycrUhHrkg8E9pbxn8nVuMBx//26Vq36P72TuVrfe2eyz+Qx89i9mQ1BhmNhhA
043DZs5oPRcfKQBUyx8ukIwDCqG/puh7h/ayVpqXeWwbToo/BVgGqkdJsRf3eFn5
Ql5RNMYEdCcXsH0mnMla9rngfv2nKTotlMpS3i6zSFznfr8+PDGUo5//Q22YNOS0
2EA6EO2tOg3hmE3pzP63ZlrLJxMwNsJCJbqG/ldAxCFusMJVsHRiTFA/gTFhDl7O
bE/Tc5odhvjGMLS+RmXE
=Mxur
-----END PGP SIGNATURE-----

--mZSo2Zk6iB5ZAp9g--
