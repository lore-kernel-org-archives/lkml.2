Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2LQDWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 22:22:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46934 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2LQDWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 22:22:41 -0500
Date: Mon, 17 Dec 2012 14:22:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the final tree
Message-Id: <20121217142238.a0840563304419bb345ac25f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Dec_2012_14_22_38_+1100_85E9_IajO6cS+Kl3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Dec_2012_14_22_38_+1100_85E9_IajO6cS+Kl3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc allnoconfig)
produced this warning:

warning: (PPC) selects SPARSE_IRQ which has unmet direct dependencies (HAVE=
_GENERIC_HARDIRQS && (IRQ_DOMAIN && DEBUG_FS || MAY_HAVE_SPARSE_IRQ))

I don't know what introduced that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Dec_2012_14_22_38_+1100_85E9_IajO6cS+Kl3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQzo/+AAoJEECxmPOUX5FE0P4P/3zQxSNb+bPM8E7yin12ZsIF
Soc/tN4SGO7nMJYud64ar5yhk3POPwhy6jsLm97eNzHofVaFJBc9YmkBF+XY1RYR
+vi5JLeSDhx1RR/GlUY4lXTrN2fCZqlBDLb9b2QXzT/mCp/d0jDP5gMBqh98vzcc
fIF1lOBW4wYhjBh2YVXdT3x3CZham826j2U0YMABxf6xdqoZYSGxF+hcUHxvl/IJ
3QN2KDtXrnceufvkNCmnxYystu+++++dZK7KtiFD1Ug31Pfgka/PPwPT6QpN42t4
mxszJnDOCLc5YtlZWf/XV2+nUrHtpM0Cb6V2M6z5/Ugq3QgYzYYGbQnHLggA1ZKl
QZL4CckogOTxre16r9XBTIDSp4kIAo5ek+WcKiHajLCOz5ZsBO1zIZEgPVTpF4XR
aRdzGUq1SEBSMjMygtevkj6EcnNj3Dmgnz1IlCSf8F8aFQoRmVRhyCDavlNUExf0
Tl0Oj7rcImPwux30RcyanzBvBZGRkbABMq/NUJLzHS1mWZbg8EJvIhz4J1i0NiSO
g+GNOZ3J1qnkdiHN12Wmq5fZ73UwkLb/bQ7bWfNxo3qZ8QLo35KIvxwWrWgm6aue
pZ7Ahr9bvWfWpMSFWceg9qu6rq6s0X6dDMpgJfbMTl5u9ij1sKXN0B2mhM3vyO99
MZW4QkGeDh9UtWT9V09o
=DDnX
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Dec_2012_14_22_38_+1100_85E9_IajO6cS+Kl3--
