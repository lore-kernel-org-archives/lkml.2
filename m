Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab1HVAsY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 20:48:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35926 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab1HVAsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 20:48:21 -0400
Date: Mon, 22 Aug 2011 10:48:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the mips tree
Message-Id: <20110822104809.451b0e8d7b231d70d73aa256@canb.auug.org.au>
In-Reply-To: <20110821094302.e46933704cd74ab7728bfc74@canb.auug.org.au>
References: <20110821094302.e46933704cd74ab7728bfc74@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Aug_2011_10_48_09_+1000_jBjQeSdSOD5HOuCS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Aug_2011_10_48_09_+1000_jBjQeSdSOD5HOuCS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

On Sun, 21 Aug 2011 09:43:02 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> The mips tree today seems like a complete mess.  It seem to be some
> historical tree including commits with commit dates going back to 1994
> and v1.1.68!  Please fix it up as it is unusable in its current form.

Since it hasn't been fixed yet, I have reset the mips tree to be what it
was in next-20110819.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Aug_2011_10_48_09_+1000_jBjQeSdSOD5HOuCS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOUadJAAoJEDMEi1NhKgbsEkIH/Raxh5FMfdNWAnNv8qOJo7yi
07Z1U/DPiQURuAh4y0NHDyfpvdEkGfA/n7dasPcS51jf1TjLv8FvpCDpsH+z/xu9
JwJaqOU1SZpazyRU6sSc3CqJTMNZCudcKh3fTjiNhJmC0gNeLpPbLAJO3X4Gsj6i
yZ94F3oGImH2nM03o9Du0CXAgOu9WNPX+GVmUJT+Q13blXMNC4bDzzMmupjZ8A5R
xiRzph92h7E5Qn7rSExI6ud72qgXMVMysHrOM0E/p4JldHgL7Y4fhtAj6VXIWsi+
jn7xwKKaWB2nmzbp6Y+3k+hEWyG/t03vJRrLO+dk4lAFS6NRn2zEWacF5cE+41E=
=Gysa
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Aug_2011_10_48_09_+1000_jBjQeSdSOD5HOuCS--
