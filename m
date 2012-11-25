Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab2KYXSx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 18:18:53 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34286 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab2KYXSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 18:18:51 -0500
Date: Mon, 26 Nov 2012 10:18:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [RESEND] Request f2fs filesystem inclusion in linux-next
Message-Id: <20121126101839.cdea3cebc6534722072e3fd0@canb.auug.org.au>
In-Reply-To: <1353734925.26584.43.camel@kjgkr>
References: <1353734925.26584.43.camel@kjgkr>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_10_18_39_+1100_P3fqq93jN2=mGFco"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_10_18_39_+1100_P3fqq93jN2=mGFco
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, 24 Nov 2012 14:28:45 +0900 Jaegeuk Kim <jaegeuk.kim@samsung.com> wr=
ote:
>
> About two month ago, I submitted a new file system, namely
> flash-friendly file system (f2fs) to LKML.
>  http://en.wikipedia.org/wiki/F2FS
>  http://lkml.org/lkml/2012/10/5/205
>  http://lwn.net/Articles/518718/
>=20
> In the mean time, many folks have pointed out several essential issues
> on f2fs, and now I think most of them have been resolved moderately.
>=20
> So, I'd like to request a new branch being included in linux-next for
> the purpose of merging into the next mainline kernel.

I have no problem adding this to linux-next (and noone has screamed aver
the past few days, so that is a good sign) except that the branch you
have submitted is actually based on linux-next itself.  You cannot base
anything on linux-next as it rebases every day.  You need to base your
tree in Linus' tree (or some other *stable* tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__26_Nov_2012_10_18_39_+1100_P3fqq93jN2=mGFco
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQsqdPAAoJEECxmPOUX5FEJgEQAIYei3cz4opyK72tB+EZSUAU
+7P+Di2hzYr/WRqM27D2SU1AXKtsb8jHAD2YwhuHtFzgqvcau9URTT+/YM2npqmi
ioZDmQDUpxqYCvBADUv1TgpXDKHLDzEDPKhxaaPKpqcFoogBeFttMnmxX31ebXah
4RlGnBVCzGIQMATV4DatSmQPAXSjlqKU3HOCMahHk1EZ2c95RFl3gRbMOB1qpXtr
pXjFMRGhRyh/V59QYlc8NEvy1zGF58UpaZjI//aWjmhQ+Ch2l+nLT7XUFl7xmiFP
nawYOEyMkjjaSwHTIRwUAz82HWeoG7lakwKjz39lSGJccWYNI+OQ5BcfsOSMXglp
T7C9gEsixaMOlgFKuXHr1gJogkm3dzYeX0YLE3NLZx7Vd/+fXDuSVfoBMS6RsXae
xmRvHmvO/lwHMfNXMI+cVC8/xnt0SaK465hUT/FFw7uVaD/C2dnLd3fwhmVm8p6J
aDOgkoGeS3yoA/pzqISoHhxzNm9y5EeqslOOfVMS08K5N9NbhVCo8kHAH9c7gqp5
5edYirjVh2XA2NspIp/93K01YFZc7YOYTD+JcylwH442UWWZajC1+hPblA3sc+p4
Qu3OlIC212nmnClEcaFHjtyiwnuUMn53LU+Mvsz4fngTdqb9bQlljK6nsWYdjWjV
RasBv86C6Eo3ZDbiDeia
=tHjI
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_10_18_39_+1100_P3fqq93jN2=mGFco--
