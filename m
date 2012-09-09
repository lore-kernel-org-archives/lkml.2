Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2IIX6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:58:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59741 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab2IIX6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:58:42 -0400
Date: Mon, 10 Sep 2012 09:58:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Brown <davidb@codeaurora.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: Adding 'msm' tree to linux-next.
Message-Id: <20120910095833.c2387ab0b7f3bb1ae9dae885@canb.auug.org.au>
In-Reply-To: <20120907220404.GA5904@codeaurora.org>
References: <20120907220404.GA5904@codeaurora.org>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Sep_2012_09_58_33_+1000_Yw7/RxcHvQJ2Q9Sk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Sep_2012_09_58_33_+1000_Yw7/RxcHvQJ2Q9Sk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Fri, 7 Sep 2012 15:04:04 -0700 David Brown <davidb@codeaurora.org> wrote:
>
> I'd like to add the msm soc tree to Linux next.
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git for-=
next
>=20
> I had removed it when the creation of the ARM SoC tree, but now that
> msm is getting a bit more active, I'd like to get it included in next
> to get it in a bit earlier.

Added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Mon__10_Sep_2012_09_58_33_+1000_Yw7/RxcHvQJ2Q9Sk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQTS0pAAoJEECxmPOUX5FEnOkP/27FIE4ToChfclzjahUYmSTx
qWUIxGSA+tQGnuTw/MwbA1/p8yRNHbO5WOwZHddZJv9JQ6iSg3Rx70T8x+Wz7MFr
rix3Vv2TqAdNRhMtMVOZ1q4oftkk/y9BPqtAiYvddwpSdM5pS92PIjd2jRhmiZo2
yBSBm6hkYi5oWUbV08ZCteXbLfcEiBk/YLeyVV5+PRTaKK6VCmxkIOTcUWmGYayt
/ILtCudF05tUOTTZ+tynprNrd4CRhIusITKo8VfoH+Uj2R9x5py58DAS1ERLWXKV
/+UykoA2MpRUKvUZRqZepCTQ4KM4PuK6VqrtVdaZRigGc95Q2kaMUkn0I1q4P2wV
oGqVDLvHadqBkAAEf66YDKVp6W18dceu7AdcA/dYZvY+Uw5ZGhA7XH5P+Fz09Y54
0RB0hQm/Wl/qyY1L3cgHqZ7ecOA+iQmTQTtlsOdazYUUupvvFMIMh90CSrEDue5O
DySw5BYT+z5ODc8aE5he+JlfQAWKZEwEewh1Elm1N7UJW8Sg8m3a+H+DPNfkd643
Noni+dJHug+9MvS2E1Rjx8p2WdCEhKDRoI0XBe6msENcgRUdUyeCm1J7X/aN0cKR
youyPV6zgSDwO7PBqg/YcgwKEeATZH8+28C21nY6Q58+mb87i4Fu+AeBwsM5TjHj
l7ZqmyD3arofh2Bbf2kM
=raXD
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Sep_2012_09_58_33_+1000_Yw7/RxcHvQJ2Q9Sk--
