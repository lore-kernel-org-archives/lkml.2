Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1GETg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:36:59 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58121 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab1GETg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:36:57 -0400
Date: Tue, 5 Jul 2011 15:36:54 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Eddie Dong <eddie.dong@intel.com>, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v5 6/9] add jump labels for ia64 paravirt
Message-ID: <20110705193654.GF3436@mgebm.net>
References: <1309793548-16714-1-git-send-email-glommer@redhat.com>
 <1309793548-16714-7-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VuQYccsttdhdIfIP"
Content-Disposition: inline
In-Reply-To: <1309793548-16714-7-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VuQYccsttdhdIfIP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jul 2011, Glauber Costa wrote:

> Since in a later patch I intend to call jump labels inside
> CONFIG_PARAVIRT, IA64 would fail to compile if they are not
> provided. This patch provides those jump labels for the IA64
> architecture.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Isaku Yamahata <yamahata@valinux.co.jp>
> CC: Eddie Dong <eddie.dong@intel.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>

--VuQYccsttdhdIfIP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOE2fWAAoJEH65iIruGRnNIlQH/2Q2Umgwcy8LYRVf5GpRvSWr
AXUyjzUB07KPvVdEDiWtRM0iRfE+xi3MZjzzK2ZXGATMMmwLMQzqnnObB7piDo2N
MA9pHSbYhL6uqJ/fgW8BIAEDd4jPnrFAYmih0xsA6LozcIXnlapMnY/zSKo+Rjkv
DjJV1ylORyMn/TF4mlTpCx62fmGDo6Lh0eOFgmQvpVaFeYMRCksLDNN/d9spnC7X
vGM3CpC8Y+2atchO4kMOYyY8Ow2K/Ynzi7f75vB4HZ5eCrxYHwsjfo3zhYNjeoG2
LbJFE+EhY88qzT5D3mpuU6YEwHR+SKoS6ysibUZLSguScQw1VSbnz6Bz1ZuKGwo=
=8/qv
-----END PGP SIGNATURE-----

--VuQYccsttdhdIfIP--
