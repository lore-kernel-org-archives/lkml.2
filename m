Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab3AIV6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:58:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50808 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431Ab3AIV6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:58:35 -0500
Date: Wed, 9 Jan 2013 22:58:15 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130109215815.GC13648@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <1357764194-12677-11-git-send-email-thierry.reding@avionic-design.de>
 <201301092122.08011.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline
In-Reply-To: <201301092122.08011.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:8x8sNGj+CLeyulyNRk3X5OOzgfHhM9IZqQ9RYrBu+NK
 yC4VolE5xonep8omacFk4I41NQ1mTCHF/oH/YZt5T4FZSY85RP
 iWzNSX8aEELOT+0YJcA2S0rqrEg+v9Piw8Jq0h2J5Td+8MJ/ET
 UKD3EGvA08Kn6Qt3kPHRz/APHuihX+pUoNTyikClFjLc9JC2ee
 2zOeSOYSvQfC4dyEAVrBIumI+aWAYrbMl0f601gn3Vq2HdNDE0
 q14yBDzbmxoEwKZznrqP9KQckNnWtaYitaetDNVjmROWe/SagC
 vQ+OHl9WGfFHyEMQYk7L1AG6yLiEtVj74KBEJQ94Grt77gelGJ
 IUwvZKBtJyTcyF/p9fY/2XiE5/PRKaeVo3pkGonET3QyvMXQP8
 V0Yb+SPj8Jv2GFaTmiV0axGqcNEj55eqwAC+VcjsKN6zLlotnx
 SbgYi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 09, 2013 at 09:22:07PM +0000, Arnd Bergmann wrote:
> On Wednesday 09 January 2013, Thierry Reding wrote:
> > Move the PCIe driver from arch/arm/mach-tegra into the drivers/pci/host
> > directory. The motivation is to collect various host controller drivers
> > in the same location in order to facilitate refactoring.
> >=20
> > The Tegra PCIe driver has been largely rewritten, both in order to turn
> > it into a proper platform driver and to add MSI (based on code by
> > Krishna Kishore <kthota@nvidia.com>) as well as device tree support.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> Can you split this patch into two patches, one that moves the file,
> and another one that does all the changes? It's a little hard to
> review when I can't easily see which code is actually new here.

Stephen suggested I post this as removal/addition because pretty much
everything changed. Reviewing the individual changes would be more
confusing than actually reviewing a new driver.

Thierry

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7ef2AAoJEN0jrNd/PrOhdEkP/2GUkig98fNrXYHKCPF9or9+
cJisvvH8SPAGt09p5RYaO5XgBGJK4XnmAdGConWD3EtKP1pk2SEYCJ5pvjNgXftM
T4QokPjKjttA1NYU8zVQhdYG1qr13is7mpNEEjCHD9q0b8TXYh1E7pvFf8KPvwKE
uE0qpbOMMdd33UsrLEkJyVPJ1zfrCrCCHUrBbSwyYgknDPb66yxTlNYOVyR0t5UP
6Nq/30GPGMiv+hl7sZeddZ9sLh5NzJE+QaElYQ0N0EW/iwzlKmKyFXUzBW9ZZB6Q
4quSKUxZKgTSCi2Urjct/zP67/d6ZGw8eeaTxgp0Hy0K8jJ4MJ4+cL9w6vUGhS7C
bqqC9TokrGVmlRyOj/wSkdoYWzbqGyIRSHcWBD3cioywfo8LQizJqcdXrgtqfa0Q
iBNDS+S/2cG25lqiCbeTwv0Q7lYWRvQjPRc4Db9HpvA1E8aHucqGV0EUqaXQOZD1
X/VSEyWVBefJiF1ta6DvCznJ0JJae4FBenlkPHYOSjF/3QJkX7PHb/3EqR6sOUw6
tqypC0HMiKA1eAa2PT9tO1fno7c+rCKSwmHLasExTF1Q6E5o6c1/rzVNXACyvFXf
isB2EcwOx/+9BJlz5UxBZNY5dmMGOOpfB/xsXMLAbe+CjIkt6XJGs8fJWuaorrf/
uTEEPPGoykfodSDltlw2
=GWfc
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--
