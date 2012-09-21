Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab2IUJmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:42:06 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:38786 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932906Ab2IUJmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:42:00 -0400
Date: Fri, 21 Sep 2012 12:37:11 +0300
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>, Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] USB: PHY: Re-organize Tegra USB PHY driver
Message-ID: <20120921093710.GC15626@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1347519738-24162-1-git-send-email-vbyravarasu@nvidia.com>
 <5052157F.8040201@wwwdotorg.org>
 <D958900912E20642BCBC71664EFECE3E6DDF601145@BGMAIL02.nvidia.com>
 <20120920120004.GD3523@kroah.com>
 <D958900912E20642BCBC71664EFECE3E6DDF601261@BGMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ABTtc+pdwF7KHXCz"
Content-Disposition: inline
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDF601261@BGMAIL02.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ABTtc+pdwF7KHXCz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 20, 2012 at 05:32:36PM +0530, Venu Byravarasu wrote:
> Thanks Greg, for quick response.

I'm waiting for a newer version fixing Kishon's comments. BTW, his
comment about pdata usage is 100% valid. You should fix that.

--=20
balbi

--ABTtc+pdwF7KHXCz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQXDVGAAoJEIaOsuA1yqREfvIQAJ48H3qF97borDnWsxu5/d4h
3/RDneiLhYFrDc9RSz1vJ10VUVqgGniMiMIEyWx6XFKIcbxklpaHBA2izFMdvsuV
Seas9s5Iv500Vc0QoS6ZkO9RGLBaVvQNT8cGlwkJbeVA34IYw2ruwlyJ5XG/l6HT
u5wusmGpzzSkU0UKVSUvsFbxZikOfKxCe3gk1zTanv1niVaL0/izS3/5sf34GnHY
9HfQr2FU4JyiyaYXbtmqBehofgZTkrCsfLKtiu7G8Pm1iwTAD7AeRhWwQm8FJNsZ
3WaEhouJ5aBnrrfcKmhtLgrf5XFV3hSBrRDyjN87lLNR+CV1XA6FW8uq7dqUybhR
/psy15te5xHzt9wBjmU+HmV8QVi48FkLahQbxEE8XlWprXVIRSfapBvxPfe9zK+0
HOhc04Wc/hK/dpx68LQPkJKaDhXsdlmjcO2mPf5Xm3/i4erj4sZlhF8Xrm4kZWxL
i/LXx2eLHghUP2IQ3/JBD6ADflRCGi3QUDrGvdAb4VLzYceAkdV7fCh5fdUfD6Nx
G01SL/O5RGNMRAaG8ZpFfroOVmSkSs1p9ojvZJoz5nz8cAdjSpDTOPwy37zgz7fU
9wlxLmkuH2vmkq8LL95ysCpmaLUF/fNqrIy4+xiGtsbSa82rU9xbySX8NLOCu8F5
mfHVAom35XTjp1N/4Pfu
=gEP1
-----END PGP SIGNATURE-----

--ABTtc+pdwF7KHXCz--
