Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab2JWRHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 13:07:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56497 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754731Ab2JWRHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 13:07:42 -0400
Date: Tue, 23 Oct 2012 18:07:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Lucas Stach <dev@lynxeye.de>, Pavan Kunapuli <pkunapuli@nvidia.com>,
        linux@arm.linux.org.uk, cjb@laptop.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH 2/2] mmc: sdhci: Defer probe if regulator_get fails
Message-ID: <20121023170723.GD4477@opensource.wolfsonmicro.com>
References: <1350976740-19284-1-git-send-email-pkunapuli@nvidia.com>
 <1350976740-19284-3-git-send-email-pkunapuli@nvidia.com>
 <1350979047.20572.6.camel@tellur>
 <5086C5F5.4070801@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kUmo4NyTJbuJZ752"
Content-Disposition: inline
In-Reply-To: <5086C5F5.4070801@wwwdotorg.org>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kUmo4NyTJbuJZ752
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 23, 2012 at 10:29:41AM -0600, Stephen Warren wrote:
> On 10/23/2012 01:57 AM, Lucas Stach wrote:

> > Does this work with boards where we don't have any MMC supplies? Or are
> > we just deferring the probe indefinitely there?

> > For boards that power MMC unconditionally, are we supposed to add dummy
> > regulators to make them work with this patchset?

> I believe that dummy (fixed) regulators are supposed to be provided in
> all cases where the platform doesn't actually have one. The fact that
> everything worked OK without them before this patch was most likely a
> mistake/accident.

That's the general idea; clearly there *are* supplies here, they're just
not software controlled supplies.

--kUmo4NyTJbuJZ752
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhs7SAAoJELSic+t+oim9susP/0AssZKAu0Kc9VvmhgVgu3fo
uP6TknKZf5pfa+U+Up9rlmjzxgmbOHIjGL1joJpUVpbL9iHuuYqqU9S4/sw/bOpy
0yJTrJzrRYWdIK0bx5g+EW6F3RPcPWc7B2ZLPiSHcPFIe6jTSrgQAPCTqAnRYnDv
GvDoy+Oya1Ztjim+uIMTuNDJ29t3xrdvwP+Ds7r/Dkz0P3fPCcbleS0NMhbctiNg
hP6jOr+roHou+TRPwok5XAoN3j/C9/6riZGy+C1TpRzMR/YLNzuTcLShxG33Pm+l
85PNQLzo27XQBn2ZOX1UyX1FKAkxK3JQ8UavR6TtkEjE5PeCiFP6sqtKdOb3gB+1
kAvK8fbhf8O7JMREFjKNVhOssFQQWOCI5IMlOtAnfuBEl/P1b1S2RXZByUX3KsOu
laI1Z3VfSMUfYiklbarHO5CCCzP1TUNpgqnboK3IJjWf0haIuLeTtUDro11lSP8V
z+zUckY+AHDilo6IUN6lFRyL8cZU/ohZUE/Snw8NiFzKevubqDQ269usWvKR6kWh
pZCisbrU29U0SYwnOH3Zf7VcpuVwjaEUjtinHrprsQhiOs0JvFcTemWYXrabhA8U
xTb158lEF1AV9MuFiZe+RBTAiTVuF1ZNnQ3mWgIBoMI8mEv3weu4ncwBz5IC+1xh
EVqnpeuK56wfTi+EMHfL
=9GG4
-----END PGP SIGNATURE-----

--kUmo4NyTJbuJZ752--
