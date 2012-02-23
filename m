Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab2BWT5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:57:54 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:48533 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756769Ab2BWT5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:57:52 -0500
Date: Thu, 23 Feb 2012 11:57:47 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] PCI: Make pci bridge reallocating enabled/disabled
Message-ID: <20120223115747.4b85fdb2@jbarnes-desktop>
In-Reply-To: <1328916832-6588-6-git-send-email-yinghai@kernel.org>
References: <1328916832-6588-1-git-send-email-yinghai@kernel.org>
	<1328916832-6588-6-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/A=.yXc0r1EB_AJvXnQp5jCe"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/A=.yXc0r1EB_AJvXnQp5jCe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Feb 2012 15:33:50 -0800
Yinghai Lu <yinghai@kernel.org> wrote:
> +enum enable_type {
> +	enable_not_set =3D -1,
> +	enable_no_user,
> +	enable_no_detected,
> +	enable_yes_user,
> +	enable_yes_detected,
> +};

How about:
  user_enabled
  user_disabled
  auto_enabled
  auto_disabled
?

enable_no_* seems a bit confusing...

also the help text in kernel-parameters.txt should mention the config
option and describe default behavior with and without that config
option enabled.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/A=.yXc0r1EB_AJvXnQp5jCe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRpo7AAoJEIEoDkX4Qk9hsNcP/2QR1BTvKR1CRO1vTPhqpMpz
EegR+Z4LGTOYKZODY7rHeOmi4owV8NkI8HsW1ZHNNWaQ3AY3LU7r/Rrbxwa5D1Ou
wJe7vTPH4DuHsSsXqNF+TpD4eORWSsV2FWuldSwW0y1GQVRjPM6zfIQjHlcQEYQ+
8VW8P+RD7AV9HsMx5+DWVFta2lzIf0NAug1Ob/P+Vxq6qFB8dVYJ6h+qB7vOhi+5
GTCVIaF2yDfVZuJRTrTsooT4YU6k0PY2I2ye8gKC2cby9rf1gBGo4W8/bEEdpOd5
2wPBkforrrhwO81RW319+RDgQUMhCtAc2LgLGAE51OXVk3XEldp0N9P4NCM5p+Cj
og5sRPJ2SZRWVhHtmvsfaeVwt4nSNS0yqQ6WDkRHE/8C5Z0duD9cBB4UIKKXAQfN
fSqXMzdiBf57ITP5j1iMbfE8P2wDbwO8ZrMo/J3qlXfCB5KXiSgxF7EWfDpHqien
foOYVhFFN6auNwS/Vjrfc5H5KfH5L0EHHnji9u5rH8SQy37YydVtYMQf0rY+QzlG
oHRLXpeopYLLp24mbOw7AhR/7Cfja1xjtvmLW7hUoRQdVKx5ykMYc2q+H9JPO23Q
lO+TvSVUlbMqdnc7m6l7xvXKHrnSc2J9biN1ORZ0MA1VV9vsS/DsU62Vgb8WMYhw
vcPKMYLjgqlDNptsQTG5
=m7Gh
-----END PGP SIGNATURE-----

--Sig_/A=.yXc0r1EB_AJvXnQp5jCe--
