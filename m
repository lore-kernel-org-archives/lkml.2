Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab1JNLiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 07:38:16 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:57854 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab1JNLiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 07:38:15 -0400
Date: Fri, 14 Oct 2011 22:38:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        matt.fleming@intel.com, tj@kernel.org, oleg@redhat.com
Subject: Re: linux-next: build failure after merge of the final tree (sparc,
 ptrace trees related)
Message-Id: <20111014223804.c955c49972b7b19b5d3b352f@canb.auug.org.au>
In-Reply-To: <20111014.035459.2238341687770152474.davem@davemloft.net>
References: <20111014180714.e11e15fd35dfaca839c6421e@canb.auug.org.au>
	<20111014.035459.2238341687770152474.davem@davemloft.net>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Oct_2011_22_38_04_+1100_n1MQAlrRdJl82V0V"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Oct_2011_22_38_04_+1100_n1MQAlrRdJl82V0V
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Fri, 14 Oct 2011 03:54:59 -0400 (EDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 14 Oct 2011 18:07:14 +1100
>=20
> > After merging the final tree, today's linux-next build (sparc64 defconf=
ig)
> > failed like this:
> >=20
> > arch/sparc/kernel/signal_64.c: In function 'handle_signal':
> > arch/sparc/kernel/signal_64.c:482:11: error: unused variable 'blocked' =
[-Werror=3Dunused-variable]
> >=20
> > Caused by my merge of commits faddf598f0ba ("sparc: Use
> > set_current_blocked()") form the sparc tree and 383fe35697e4 ("sparc: U=
se
> > set_current_blocked() and block_sigmask()") from the ptrace tree.
> >=20
> > I have added the following merge fix patch for today.
>=20
> Now you guys are creating conflicts against those fixed up patches in
> another non-sparc tree, and adding new kinds of build failures as
> well.

To be a little fair, this particular build failure was caused because
when I did the merge, I didn't notice that the "blocked" variables needed
to be removed.  But otherwise, I defer to your knowledge.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__14_Oct_2011_22_38_04_+1100_n1MQAlrRdJl82V0V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOmB8cAAoJEECxmPOUX5FECsIQAI+EmfQyM8kGOLzpoWT1fMBX
q/zJM0trell8SRxuSz30icb+8IIJPGLu3Vs5I9nfgrGaLOLcN4OsmXO4ITxx+l0e
SAkx8SIU26vAQPyvkYSn2AmKXUDFTyc8cdW8rMhV9AhQnixo28K9swW+yoS+GdfQ
ak7DZjuma5TLP/mkH2FfHmnPF8UeWjobnpURqg+uPktp7eTYngVzBm3oP1D3I84z
viEyhL/1hBt9fYZZe2MiQ5NpiK452fQ5szdaIKWX83g2G98GjbXnoemN97uPbXhq
dF2Wt8DPY3CuyQgKpAVUQAaO4D3PKJ5dvWa/fDLr7zQI9Y0CCBaebe7PQ/PIw05H
dyrSIEZk9BuPbUmjfAXEOJN44/HOQ5WRRjwJWy7t+CknIIxEjEaKgXxGKoKdphpZ
/8FbXLx4waoHscsq4sHAIJuvAsgH8AYej8gkKxCDtkTEUOIWh3/S15tEEXXxp/6v
5GELnH5SiyaAdBNJMvWTXDh5Z8+vBV9XycaDJZqBbYrn6fg68pZ754m+jcLLJPv1
plrqxz63be9x1Eqo7Ri+IZPrNuT+7QmiOgTFwOSIk16Wx++7AeCkpAJiK++1dBqR
JIBGLUYYLmAV60aKrLWCoNXKK6tF/lBkQAHwwX/7YXHMLGCM0dYXeIYCZoMqeZzu
chZLUHaBcsRkJ2hCfU7I
=csLc
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Oct_2011_22_38_04_+1100_n1MQAlrRdJl82V0V--
