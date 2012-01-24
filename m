Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab2AXQhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:37:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:1289 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186Ab2AXQhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:37:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="115628685"
Date: Tue, 24 Jan 2012 08:36:59 -0800
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Kay, Allen M" <allen.m.kay@intel.com>
Cc: "linux-pci-owner@vger.kernel.org" <linux-pci-owner@vger.kernel.org>,
        "matt.wilcox@intel.com" <matt.wilcox@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jean.guyader@eu.citrix.com" <jean.guyader@eu.citrix.com>
Subject: Re: [RFC][PATCH 1/1] check for pci bar restore completion and retry
Message-ID: <20120124083659.0e2302b1@jbarnes-desktop>
In-Reply-To: <1327362955-4137-1-git-send-email-allen.m.kay@intel.com>
References: <1327362955-4137-1-git-send-email-allen.m.kay@intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//71JbOe2e1uowBSzpplDG72"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//71JbOe2e1uowBSzpplDG72
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jan 2012 15:55:55 -0800
"Kay, Allen M" <allen.m.kay@intel.com> wrote:

> On some OEM systems, pci_restore_state() is called while FLR has not yet
> completed.  As a result, PCI BAR register restore is not successful.  Thi=
s fix
> reads back the restored value and compares it with saved value and re-tri=
es
> 10 times before giving up.

But shouldn't we be doing this wait in the FLR code instead?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_//71JbOe2e1uowBSzpplDG72
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPHt4rAAoJEIEoDkX4Qk9hHXsP/RgEzqkU1LpqQkgfRJs9lf0G
rFM6UhvZAx1WetyddEaC2ASJXVhzjnFLceJJTnUYOfF/FfrcefnXwQzxMn25jptW
SPeQ2WjMaMZ7PDligIW75mDOu9IBWCg377hxvUXFno+xAFeVit3866iglD7hNZ22
vI55ZyhyaVyWTlyhksEAmkmepfCv2ONHI9hRdpaWR1rypWNtDPkmkuQW8ubAZYFc
ouX40xEwJx2zphPLNFZXDeChR2Dsl4zwNARhbIlTO9P0IaJINSX5q5t07jfoXJpB
+AZn1Uiyz+3gd+igFydyjabN7q0tPTGbSs+ESzSVyhS8BCWoz8zMtywhzv2zfIp+
+FZpHuHZonKwNnNmeXjnsU8A4zGNg1GjtLh0fRqsF/6ikTbnda3mBdrTyPIOXes7
BuHL8v07IYvnb8hDkKVi3V8untb32h51R8zQHGb549CgUOGER3CJuuWso+Fsig2y
dcXznpbMehN/vssOxsiJsu6DVysLzvRY9BL46yoMJInitlTEp530Jj1KWKc4WNNs
W27iPJIrUBf6+PTCpZbs2iPLcEtsIZ3sjQIBK3og6vSzFyHyTGBjHcIpRJgiacU/
OBqTZv3Xwvt6uxy3YF3WAL63ruSjs3dHx2Q6tjS7N20Ajci6n9PD9K9Xq2ZbW0Mo
b/6ra4z92sMXfoFic21E
=oZlF
-----END PGP SIGNATURE-----

--Sig_//71JbOe2e1uowBSzpplDG72--
