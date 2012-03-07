Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab2CGGKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 01:10:49 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:32215 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2CGGKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 01:10:47 -0500
Date: Wed, 7 Mar 2012 09:12:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: mchehab@infradead.org, dheitmueller@kernellabs.com, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] [media] dvb: negative value assigned to unsigned int in
 CDRXD().
Message-ID: <20120307061254.GQ22598@mwanda>
References: <1331091663-4790-1-git-send-email-santoshprasadnayak@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FcSpk3Icpd/Pbul4"
Content-Disposition: inline
In-Reply-To: <1331091663-4790-1-git-send-email-santoshprasadnayak@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090208.4F56FBDE.0013,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FcSpk3Icpd/Pbul4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 07, 2012 at 09:11:03AM +0530, santosh nayak wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>=20
> In CDRXD(), Negative number is assigned to unsigned variable
> 'state->noise_cal.tdCal2.
>=20
> Members of 'SNoiseCal' should be 'signed short'.
>=20

In your changelogs could you please write something about how this
change will affect what the user sees.  That way users know if it
fixes something they care about and they will apply your patch.

regards,
dan carpenter


--FcSpk3Icpd/Pbul4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVvxmAAoJEOnZkXI/YHqRAbkQAIy8RpIKTMxYKM+PF7HbH4P8
xWLqR5e2txpBRlC/Pgp5FjmG/qB4utg4FuGibRctGnUoSMP+ayqE2/QbBfKVqQRi
e9E3Y9HB6hHZJJoFQA3v6ZGbAWcGxF4+T3vZuq3F7+LI6gnKbtxqefJ7nsPKyI1t
KEwjCbsrziGS/VC+WFyZTdm41vWQ5yFCtc28fd9eiGfJ2Y9o4a/7CkrbvQ15r0Lo
R5gk7QtsQGZvoU9yf5FB15cnBl1ulor0PAZKLhwzvSAnIZINDAmVVHG0mGodSES8
aR1PtS34GFL81EP4Nw57NEIZsvcrw5mMbEvrmzeKa3ghurPAfPlwaPbV+cJkN9Zc
QF8EaFxzZ4bvT9PKGmRSUkw9QVO01W3MVBTY5oJI3sx9G4O5bZmcSdrF+Radlj3A
Lmh0Z0f9opxjL1cKMdv/yzRwQUZBGhAW4sz2VRFmKHHY6yMDTmvAiQuToWFZh1h/
+Pc/UrvwY08nupDr2jsB9QszPHFrRXqxkbjZXqI9ZRqeHc53dUi0oNgcuhE5zIhC
T+oxTxkG5f7IXE5DSvm/f8QGBCYzuUS26tTzYGH43amOr1VUkwy/xn2sJLlR05ZW
fVRCfXFMeIjTIfytOCtO8KpRBXlhA6hdzamazvr6L37sT2Co9A671OZIxKa8Yuua
bfL9GVFppnX56VNEBdZj
=u9IJ
-----END PGP SIGNATURE-----

--FcSpk3Icpd/Pbul4--
