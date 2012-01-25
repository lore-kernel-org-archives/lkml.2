Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab2AYNc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 08:32:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40915 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752664Ab2AYNc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 08:32:57 -0500
Date: Wed, 25 Jan 2012 13:32:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, rob.herring@calxeda.com, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>
Subject: Re: [PATCH v2 2/2] regulator: add device tree support for max8997
Message-ID: <20120125133254.GJ3687@opensource.wolfsonmicro.com>
References: <1326353738-26864-1-git-send-email-thomas.abraham@linaro.org>
 <1326353738-26864-3-git-send-email-thomas.abraham@linaro.org>
 <4F1FD1A5.1060305@samsung.com>
 <20120125112602.GB2991@opensource.wolfsonmicro.com>
 <4F1FEF55.8030604@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AwgMNpd3VkAVXjS"
Content-Disposition: inline
In-Reply-To: <4F1FEF55.8030604@samsung.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AwgMNpd3VkAVXjS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 25, 2012 at 01:02:29PM +0100, Karol Lewandowski wrote:
> On 25.01.2012 12:26, Mark Brown wrote:

> However, I still find it little problematic that dt and non-dt
> versions behave differently when given the same set of parameters
> (previously apply_uV wasn't the default and required explicit flag).

Well, they're different things.  Device tree isn't Linux specific at
all.

> Thomas, would you mind adding small note to pmic's bindings
> documentation stating that Buck6 is basically on/off switch? (Thus,
> no voltage should nor can be specified).

At some point you end up copying the entire datasheet in there...

--7AwgMNpd3VkAVXjS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPIASAAAoJEBus8iNuMP3duZIQAIj4npNcHRTsEkmDHvqVnblH
9A7kYgnjVQM7o1mf6sbTIIvS21HnT8tFKhFFf+SHB80rSmyPOluLhfnRx3BzYHgF
cSPLn9+4ePlhhDBHpWlhIiawkPR0g1SFveZKb8Qcxvap7W2MpKn2ngoCksrMvaSd
IYRZXcI2Zk6B9BbXFPFYYbUkCESEzdOLWA45RO72zvyUr1TLXO/9Dpx8x70Z9dUG
9+GdjmFsVqs2NkXAHfS/RN91xR38mYdXR9yhY66xYP+mRGjOb0uWai2PZBGYR6xv
7d86fDLkgTFcz+ZowEKsrDdJKcLbgYeqkiYjZhGHOfJnZ3w9+0Xfku4ydsm5J9In
HasRPGUGYT8GM59WfjKjarrYSyqD7BwnadfPs5aQkMIB8ODer0n+9VauP8d7ui6e
+DHLP7swB2hctxxWKn61t2rdde5HayIuEBjGO0qBFs3WDTPP6KfLuQf+G4equNXE
BEDSuclI0aQYmuSNZy4m618vfZkgx7Hjmsiup4esqxPXXaXTCE2nX2TssSh2qxT2
J7YiHDXYYKeX9ln9xTGRvupCbiCcaRSnLZbYt1PHT2cVb9fFX72WkSpA/TKUrpAG
887aniqXpwkgv7U9FDcYFNGX5+V5h7QvW5fpdFBiSiPn7vjml0nm6vhX/KIeLo6i
ZGcbm6A/HYkCwK9I6RRx
=ErFS
-----END PGP SIGNATURE-----

--7AwgMNpd3VkAVXjS--
