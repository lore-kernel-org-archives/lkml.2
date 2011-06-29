Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab1F2V51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:57:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57157 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab1F2V5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:57:23 -0400
Date: Wed, 29 Jun 2011 17:57:20 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v3 9/9] KVM-GST: KVM Steal time registration
Message-ID: <20110629215720.GH3557@mgebm.net>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
 <1309361388-30163-10-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K1n7F7fSdjvFAEnM"
Content-Disposition: inline
In-Reply-To: <1309361388-30163-10-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K1n7F7fSdjvFAEnM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Jun 2011, Glauber Costa wrote:

> Register steal time within KVM. Everytime we sample the steal time
> information, we update a local variable that tells what was the
> last time read. We then account the difference.
>=20
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>

Tested-by: Eric B Munson <emunson@mgebm.net>


--K1n7F7fSdjvFAEnM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOC5/AAAoJEH65iIruGRnNd5QIAIN3v52zqVtDHgo5KrCjhJ1z
V7dgvdnxMmZGr+IP/XCl+AwfffHByRvh8jjs0bBnzXKWmLphripfmQIRDlchIpbK
GaYJn6E7Qldy76to244BuDE/EmGSeF1RuWxNvoxlBYjarmnzNqbr0u5ySR3WAwHm
qG21TPXskPSkBPGdjFEHEGJW+b4p2cH/7a9TdfoJ0MgfnRBrMaQxkeO79Vmezqvb
7TVsvZgJ7N4qK+EioI7BRL2ZtrW1mHThDxj7S2g/VOeSW3F4p4/7tLVbUpjxre94
v+GVl85bmtSkf2cb0iVroEqxNEcDnJMGRnA/VoRr63O0rPgwZz92nXuuc24bYc4=
=mVna
-----END PGP SIGNATURE-----

--K1n7F7fSdjvFAEnM--
