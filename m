Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab2A0ToW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 14:44:22 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:48396 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751688Ab2A0ToU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 14:44:20 -0500
Date: Fri, 27 Jan 2012 11:44:16 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Kay, Allen M" <allen.m.kay@intel.com>
Cc: "linux-pci-owner@vger.kernel.org" <linux-pci-owner@vger.kernel.org>,
        "Barnes, Jesse" <jesse.barnes@intel.com>,
        "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jean.guyader@eu.citrix.com" <jean.guyader@eu.citrix.com>,
        "eric.chanudet@citrix.com" <eric.chanudet@citrix.com>
Subject: Re: [PATCH 1/1][resend]  check for pci bar restore completion and
 retry
Message-ID: <20120127114416.2621963a@jbarnes-desktop>
In-Reply-To: <1327602353-30966-1-git-send-email-allen.m.kay@intel.com>
References: <1327602353-30966-1-git-send-email-allen.m.kay@intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EIytwQx79c31M4BUInluhbq"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/EIytwQx79c31M4BUInluhbq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Jan 2012 10:25:53 -0800
"Kay, Allen M" <allen.m.kay@intel.com> wrote:

> On some OEM systems, pci_restore_state() is called while FLR has not yet
> completed.  As a result, PCI BAR register restore is not successful.  Thi=
s fix
> reads back the restored value and compares it with saved value and re-tri=
es 10
> times before giving up.

Applied, but I don't think I got an answer as to why we don't do this
delay/check when we perform the FLR in the first place?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/EIytwQx79c31M4BUInluhbq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIv6QAAoJEIEoDkX4Qk9hGPYP/0Cf2eLBPc7DRMkuOTVFqudF
VFTpViIwTxBVoe3h1VqOwwgtASoJNnEG6UsVs9esFYUIR/fWZEj2tOYSAfjT4RAM
3BRrZSBiuxCAEHj/Z9QkXcP2Kw9sgUr51WnevB/dRSDsharJOOlGV5lBgM+NySos
XjcpKpkhEJmnvSCON1Y9mNeJIUin+lMttZatKcJDPhuCBpjtnJ+qhlPoDYXPd93W
5ud29PNvWV/zfmZa4a/5GkUrdZ9h6bFMo9ZSRZEm8K03UlIGvMazvkIc5PXr1Ice
nZ0Eye3KZzf2GKQ5L6/EaJz39zvkzNQJKkJTWp2h2bdSUVF5sFm3WGKU3Hv192WX
MXh96sQ5kDPRHqX8Kd42CHUE3b5fjBTIizOhgnQYuEDVAwJK77Ozrzg43Hef2aX7
vlN7AI/YMIj51JIrdh12PUU8VAFskQBeHfTFvsnm2D4LhiiceTv75QjpgKYK/Se0
/ZezgSWn/iQemQQxYyJL+X0o7vqD3gglbBfrH11YUFDtLciwKj5PelU1SHZyTPEM
4hP2hdxjza1y+5jNX5OdGSzzGK5BUfvHANqyqoeCAJgGysGaxzOEE4Phd9aSWcBe
aIVrzKwCap6tDlfVIKYB9j0CHIDRl8lnZe6q7yBtuP3OtbuaXZkuHpnXUFvTVgMT
CAj/jjIIz9mSSOHZa1St
=MRNu
-----END PGP SIGNATURE-----

--Sig_/EIytwQx79c31M4BUInluhbq--
