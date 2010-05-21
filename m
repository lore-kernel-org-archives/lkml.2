Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab0EUBJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 21:09:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44034 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab0EUBJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 21:09:45 -0400
Date: Fri, 21 May 2010 11:09:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the kgdb tree
Message-Id: <20100521110938.7bbbbf59.sfr@canb.auug.org.au>
In-Reply-To: <4BF5D8AF.6010408@windriver.com>
References: <20100323150443.608ad7f0.sfr@canb.auug.org.au>
	<20100325154307.9cdeae10.sfr@canb.auug.org.au>
	<201003242159.25770.dmitry.torokhov@gmail.com>
	<20100521102158.bf6df441.sfr@canb.auug.org.au>
	<4BF5D8AF.6010408@windriver.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__21_May_2010_11_09_38_+1000_JK.m8j92zw6_Gi+w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_May_2010_11_09_38_+1000_JK.m8j92zw6_Gi+w
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Thu, 20 May 2010 19:49:51 -0500 Jason Wessel <jason.wessel@windriver.com=
> wrote:
>
> Before brute force toggling it, it seems we should check the value and
> restore it after the execution of handle_sysrq().

Indeed, at the time I couldn't find an easy way to do that.

> I'll have to look and see if there is an access function for this.

Great, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__21_May_2010_11_09_38_+1000_JK.m8j92zw6_Gi+w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv13VIACgkQjjKRsyhoI8ziTACZARRVTGV44Ta9YCL+ue0Vh0nq
RL8AoKEUWXyBVNnVdFae1/lurA0mFwQd
=pQ/f
-----END PGP SIGNATURE-----

--Signature=_Fri__21_May_2010_11_09_38_+1000_JK.m8j92zw6_Gi+w--
