Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1KGKd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 05:33:29 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:57787 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1KGKd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 05:33:28 -0500
Date: Mon, 7 Nov 2011 21:33:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: failing to fetch the sysctl tree
Message-Id: <20111107213319.01f37a306f1c29faa386891e@canb.auug.org.au>
In-Reply-To: <m139e0q0n5.fsf@fess.ebiederm.org>
References: <20111107095835.208466a386fbcf046c512d70@canb.auug.org.au>
	<m139e0q0n5.fsf@fess.ebiederm.org>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_Nov_2011_21_33_19_+1100_dekgjeUGKPG1J4QC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Nov_2011_21_33_19_+1100_dekgjeUGKPG1J4QC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Sun, 06 Nov 2011 15:41:50 -0800 ebiederm@xmission.com (Eric W. Biederman=
) wrote:
>
> Something weird happened when I re-uploaded things.  Apparently hitting
> Ctrl-C if when you are uploading and realized you forgot to clone from
> Linus's repository is fatal to how git.kernel.org manages things.  Last
> I checked I could not even delete the broken repository.
>=20
> Can you please switch to linux/kernel/git/ebiederm/sysctl.git instead of
> sysctl-2.6.git.

Done.

BTW to remove the other tree do this:

ssh gitolte@ra.kernel.org unlock pub/scm/linux/kernel/git/ebiederm/sysctl-2=
.6
ssh gitolte@ra.kernel.org rm pub/scm/linux/kernel/git/ebiederm/sysctl-2.6

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Nov_2011_21_33_19_+1100_dekgjeUGKPG1J4QC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOt7PvAAoJEECxmPOUX5FEa7MP/1LbKfUFj7PVQ9JYdBQW48q9
pOq91X1/T3NKNRyagFLMO4bdL3ZJU/0FND99IiF4VZmgFGKA7VzmPtlBpf+oudoD
yqDFSQt1o3LSayBhCx85aE4LhchIeDLcmUzttiQLULaEi3/IexDlcV4SLKyR1VnT
qr64IJMD/A/wr/3uR/tnPmtre2M99p7qOEHDAyG/v4dc+U8gZ1FSWUG1st/Si3Kr
LvA71QV1a/zbB3DZNp4Xh3HNlny9jGSLocd5dwaeLmNX3n5EYaRteyxAB4C6XaWW
pD0gReudAbfxD7QbDJN/T4ZBaAlhRIQEKG3c8NZ89Psti554E9hfLX9iLFHwaifN
kxUS1jWPmmNoxS6V7Xn59VT/0bAPVYUBUkCM5IE3tjzs9ySRKjhoEisf9/mTLZHb
eCTmCNFjXf0uU/lEiP+Xn6tpvwyS0wfckrqoOwi98+Hx7opwC4cD5reQvMH49qbV
4WGxMRi0GRBuRcsL1BPzJnClsMlzJ4gUsYF/yD2R3CIivKTHr3BjC6KtcOEM2aJN
Pc/4IIU4XjqI95/r4VEiD8V7gaU6UJzDpEKWhYgGBah+OEzaCFD/yrQpsXJVO8m0
uxwICV2L3O/CuXh7YaoXPgzGuAh7urn5I/1s+N1/5sCS2pP6V7obPkrXmFvtbYQa
YlA+FVo0Llv7CDyiw1bT
=wiOC
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Nov_2011_21_33_19_+1100_dekgjeUGKPG1J4QC--
