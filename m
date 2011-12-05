Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab1LETQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:16:36 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:44417 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932191Ab1LETQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:16:33 -0500
Date: Mon, 5 Dec 2011 11:19:06 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Vincent Palatin <vpalatin@chromium.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Olof Johansson <olofj@chromium.org>,
        Sameer Nanda <snanda@chromium.org>, Ming Lei <tom.leiming@gmail.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] PM / Runtime: make PCI traces quieter
Message-ID: <20111205111906.7cae2946@jbarnes-desktop>
In-Reply-To: <CAP_ceTzQ45tJQq0Vd+jR1t1Cf+AAL_wAJXpNjPKOmZ2tFkPWKg@mail.gmail.com>
References: <CAP_ceTyXLO=mv1Ott=g3mG0y+Q+VUM3N8CA-Fqa-_=uj7LTbmw@mail.gmail.com>
	<1316628308-32580-1-git-send-email-vpalatin@chromium.org>
	<201109212029.38899.rjw@sisk.pl>
	<CAP_ceTzQ45tJQq0Vd+jR1t1Cf+AAL_wAJXpNjPKOmZ2tFkPWKg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DE8/5XY/8q5JwUjwrnCKR=."; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/DE8/5XY/8q5JwUjwrnCKR=.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Nov 2011 11:15:43 -0800
Vincent Palatin <vpalatin@chromium.org> wrote:

> Hi Jesse,
> Any comment on that patch ?

Yeah making these into debug statements is ok with me, but I don't see
the original in my inbox.  Bounce it over and I'll apply.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/DE8/5XY/8q5JwUjwrnCKR=.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO3RkqAAoJEIEoDkX4Qk9hRh8QAIbxKanS6ygRlYYOjAc1HL/w
+hvnVy1OKakskpwKe3368tAF5F48BUlk31XBoEzYA2oCXTW1ZRbL8B6TCoza+PUg
4cuWDCpmNL3/YWctjQfDuDG9O5Lg8g/h/bebN6/bGhLBZ8w+T5CfRS1vAuGjIpzh
RJLTwxlTrA6OSB1lRDRqdmu85ckw/jSbCKvFhjXu8ccI4YZ8x+hpUpYUu1e8GCx4
999Ia833EH8TK0Ndq4aQphc6cAZgG5jnqaJgjwQIEDY725wqpJmTeOgd3uzsncV2
p+OXp2ke0aBffy02HlKyod4Zjif91vBVmF7oOSRhlKa4sgyPmbd2t7gFvn9TuTez
m/Vp+i3toKA0LOXEE8YXLgqtxipzRjezemxRf166ciCqFZJPfw4oBFzQcTHnRLLQ
RpuLU0AC/xYEv+hhYebVdnBx3jGX9vaVTu9KIpaDWfURnuBUEKzlDh9Y0tplQPzY
wetPPj+32Hdjcw/+1jB710JU97d2/LWHiCyxoWPb9GDBcpn2n6XhCHq8UmLEwVif
Z6e0UZt/b/modqXnO640stFD4acB6t6YkcuZniRjN4n/t07aCkmD/ZBDtdBzG2LN
/sdzKORDhnxD94brTigz4aPceqp11ccCxM/8f6Vk+zKY71ueCvFbZNvWyYJ+D2OQ
hTBeIGKetynehP6Xz5z1
=achh
-----END PGP SIGNATURE-----

--Sig_/DE8/5XY/8q5JwUjwrnCKR=.--
