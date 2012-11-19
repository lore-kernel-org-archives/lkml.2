Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab2KSGpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:45:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54557 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2KSGpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:45:50 -0500
Date: Mon, 19 Nov 2012 07:45:43 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Zhang <markz@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] drm: Add NVIDIA Tegra30 support
Message-ID: <20121119064543.GB21890@avionic-0098.mockup.avionic-design.de>
References: <1353041889-3114-1-git-send-email-markz@nvidia.com>
 <50A66A02.6030608@wwwdotorg.org>
 <50A9CF4B.2040308@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
In-Reply-To: <50A9CF4B.2040308@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:yPv4lsDB4Uqq4IXkvXCZROUeHDr/HKqCJosBgomIQAY
 LVnNOuuaXrCqctQKsjj9SiGq1UtZLaESdvGMFqvRRnrrmHbo8c
 P3vTKDkDVd6Td+qjVRNlOnRI1C7le//S7GCiBTI4Usr/hu4Qyi
 fmrv7dsc0bs9gfMUmuVgNPV/j8hPe7sTGwMJhOhU1SufPLZIF3
 bxVj9hQcLUzmvg57P1Je3+DX/3OOZjvuq8OIoWTyTHJ5hkpZh/
 6ibb4UsqgmkPdeUHmYW7/ZqCatR6B+ySIkzmvbG2tPHFztgJOR
 tNLFYrymhwVgimjlibn8SlpKkfMSkJYD4M4fb0JWQjcMtVU/Y0
 nuQZgG+CfDvGSt7a2Wxwq35lFi3ThG+2Cv+Q3Enc0GSeYBn7vP
 q2+OsSLylx3wPI7/eD3ATv1YP/J7+NtrqkQR9vlNHGLH+H55DD
 TMcE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 19, 2012 at 02:18:51PM +0800, Mark Zhang wrote:
> On 11/17/2012 12:29 AM, Stephen Warren wrote:
> > On 11/15/2012 09:58 PM, Mark Zhang wrote:
> >> This patch is based on Thierry's drm patch for Tegra20:
> >> - [PATCH v2 0/6] Device tree updates for host1x support
> >> - [PATCH v3 0/2] NVIDIA Tegra DRM driver
> >>
> >> It adds the support for NVIDIA Tegra30.
> >=20
> > Mark, I tried to apply this for testing locally, but it doesn't apply.
> >=20
> > For some reason, all the whitespace in the context has been replaced
> > with spaces. Are your local copies of dc.c and host1x.c indented with
> > spaces for some reason, or did the MS Exchange server corrupt your patch
> > as you sent it (I've previously only observed inbound corruption...)
> >=20
>=20
> I think that is because the whitespace in patch which Thierry sent:
> "[PATCH v3 1/2] drm: Add NVIDIA Tegra20 support" are all spaces, not tabs.

I'm pretty sure the issue must be inbound corruption caused by you email
setup. The patches I've sent use tabs properly and I've never seen my
setup corrupt emails.

It seems like this is not the first time that this happens for you guys
and I think I remember it to be the reason why Stephen switched to using
his private email address for open-source work. Your IT guys should fix
this, really. It can't be that hard.

Thierry

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQqdWXAAoJEN0jrNd/PrOhbr8P/2SI8sBTYovAXDKzTWsnp+F8
CixrrEfg7JnGRmyB3+Nl3yXaBcM+DcAndXAuk0A5XmVldaecE7b/2ElZpsdS3XQT
QPFSIpgcmb6oXDm47FvbbHf72oVDoOBadG0cNqubBDgvn3mhekhhUmGW5MBC7KSE
535edsljCYaEnUV1caHKJ2aKfbzuv1HOczQFYP4bwnV6DYM/bSxk0LI5wmz8FzDj
68mGqbwXvyU76agH/22eAa6Pq2uimymydYgmAIgWT74LYlpVsfiTofFMLO9Ud2iW
l9DFeVjlCF6Akt4wRQwCTRSUkho62/phWH92ZJmqK8z/m9LAzk2WivaauGx4TucO
wHRM2cOpfCoAY+tWD+NIin2WPD91bxJMqxjAiHvUTRXD+rahYaQ2G69NS9Y3cacR
SmSn1At1qo6MsYMAGA07JvUXWw5QRP88RSUOb8eihoKSDGh6HG7rE4jNAnxaWvd4
ojydaC8vERMnniRMtPuDH4QVzxcuQFav9wx2H/6m+ZGHsZKhRlPiNeCldkWstIL/
tsWmV+5bi8+mqY1IbYMRVmchotVM9yi/GhT4AgIqKUmF19L/OEQMIHC7TiMZqC/4
dbRcY2bAwbCCNslCDz5VrbRd+ooknzisvzKhoCCFmkeFwdylg+kGM/MIE14BfW63
cGFYQC40pktcVplqTS1w
=mIEV
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
