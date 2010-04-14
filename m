Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab0DNGqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:46:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57237 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab0DNGqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:46:31 -0400
Date: Wed, 14 Apr 2010 16:46:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the tip tree with the limits tree
Message-Id: <20100414164623.6440ac19.sfr@canb.auug.org.au>
In-Reply-To: <4BC5637C.4020606@gmail.com>
References: <20100414135905.47494958.sfr@canb.auug.org.au>
	<4BC5637C.4020606@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__14_Apr_2010_16_46_23_+1000_bscMGn21PqFsnlyx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Apr_2010_16_46_23_+1000_bscMGn21PqFsnlyx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On Wed, 14 Apr 2010 08:41:00 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
>
> Hi. Yes, but as I didn't understand the way he described and didn't get
> reply to what I asked, please drop the limits tree from -next
> completely. If I ever get it into a usable state I'll apply you to merge
> it again (or ask akpm again).

OK, I will remove it tomorrow.

[Andrew, not sure if this will affect you much.]
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__14_Apr_2010_16_46_23_+1000_bscMGn21PqFsnlyx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvFZL8ACgkQjjKRsyhoI8xANACeM+M7WcWOglFmePXfopzuZ9cN
anwAoLROH56+ia04nJeXalVGaKXyTZAO
=PS+d
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Apr_2010_16_46_23_+1000_bscMGn21PqFsnlyx--
