Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab1FNBVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 21:21:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47243 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab1FNBVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 21:21:31 -0400
Date: Mon, 13 Jun 2011 21:21:27 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH 7/7] KVM-GST: KVM Steal time registration
Message-ID: <20110614012127.GI5341@mgebm.net>
References: <1308007897-17013-1-git-send-email-glommer@redhat.com>
 <1308007897-17013-8-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hABqaeELJqnDDeDE"
Content-Disposition: inline
In-Reply-To: <1308007897-17013-8-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hABqaeELJqnDDeDE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Jun 2011, Glauber Costa wrote:

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

--hABqaeELJqnDDeDE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9reXAAoJEH65iIruGRnNCmQIAI0StP2Zsevkfuywm3+3Y/vX
qxpfIw5hWDeCm0VVLHLRfeviiwmySfZ91R5AkjKad8jzTGPwn08zPxmHyp6+M7Ab
pYDvHAMmsow39YdEhYN2Hfd9BD3A58WG7nG96LDQCPxx3BXHxOP0xeHIC6dM9JqE
yjiTOQqpHatt4I6GtOrvlgMRNbVWEgmJrSmSa8MUajN8E7P4Ax+ZVXkvaRgClIHd
7DrNUkEpv9FfocxTGSKVoGyezWYWjitZ/suALcgE6Wgm6i6/ErhTgcwE034s8e6h
jEDIhoB1KEcln/GGN2o6QjuLP/nAern2Jy2WnOnbLf7vn0aORonL5TTutS3dSFU=
=5k/9
-----END PGP SIGNATURE-----

--hABqaeELJqnDDeDE--
