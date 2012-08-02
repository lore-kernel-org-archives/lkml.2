Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2HBWMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 18:12:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:5581 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab2HBWMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 18:12:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="201629791"
Message-ID: <1343945532.2132.66.camel@jtkirshe-mobl>
Subject: Re: [PATCH v3 17/32] PCI/igb: use PCIe capabilities access
 functions to simplify implementation
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Date: Thu, 02 Aug 2012 15:12:12 -0700
In-Reply-To: <1343836477-7287-18-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
	 <1343836477-7287-18-git-send-email-jiang.liu@huawei.com>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VcqxswrRzIV8jL/06dkW"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VcqxswrRzIV8jL/06dkW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-08-01 at 23:54 +0800, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
>=20
> Use PCIe capabilities access functions to simplify Intel ethernet
> drivers'
> implementation.
>=20
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c |   27
> ++++++++-------------------
>  drivers/net/ethernet/intel/igb/igb_main.c  |   12 ++----------
>  2 files changed, 10 insertions(+), 29 deletions(-)=20

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

--=-VcqxswrRzIV8jL/06dkW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQGvs8AAoJEOVv75VaS+3OJrwP+wTm9Gqt5VsASxKQ/wqkAn/J
QeSO2RZTfW/iXedLk40oEgMlveb/twbuhQ4riG4aFvzXX0ilAihH7MTNNSFL0B97
bO6blIDqFcJlEV4xsiALSnD8yXrQec6Z0GP5FBUd7mmT9absIR80Xvth+c8ntpgM
Z1CeLJwYy51Oeq4S5eX3k/SJ8n0bcf1sCTpeYEFLlFpp6J3r6N74Qa0jXvJ0cSbX
rkrLOlDf/YNe3RWpEp7LTXR7p9r4S7phRx2/YXM3psfUga3h/zsq0i73Pz244I7l
+yeTNxCd418marj8qCI6UwE9oG0GdB82acOCwI4BHfCQ9lilW8B+2REpTIW1Ltl6
2rxFq7eEjANakNA0ZDD5yeZnhMQqqwjGFhZ5mo6iH7MZINo3VoDayX7qzE8tjg10
HM4cDy/PAcKOgEYR6g0Ii7sbm92mOB74XlFOX4KgIs7rUzqq2TgnD5gRl7gKJKFc
16rtaAVX6sHM4/PkBksO2i4avCEuriKap7HPZS+foA0wJOwONljMUCcOPSjrJ34/
FLFrGlilnlq+Qu9VtIVhXahZVCeIL3oaAqd5hzzfzN7yoPDt4YXHViJBur4jy3Le
HhkU82m38y39cVh5zzfIrPAjBfCaw8gPI631BipVqf05GrVQGtGlaYlqW7iZ6lib
AkfcKw3oQJHsNwdNffzr
=0t/X
-----END PGP SIGNATURE-----

--=-VcqxswrRzIV8jL/06dkW--

