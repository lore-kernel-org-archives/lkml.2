Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030483Ab2GMFwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:52:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40092 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030184Ab2GMFww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:52:52 -0400
Message-ID: <1342158454.23418.16.camel@brekeke>
Subject: Re: [PATCH 0/3] fs/ufs: stop using write_supers and s_dirt
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Dushistov <dushistov@mail.ru>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Fri, 13 Jul 2012 08:47:34 +0300
In-Reply-To: <20120712224538.31cb1e18.akpm@linux-foundation.org>
References: <1342099688-14894-1-git-send-email-dedekind1@gmail.com>
	 <20120712155808.807ec3f5.akpm@linux-foundation.org>
	 <1342157684.23418.6.camel@brekeke>
	 <20120712224538.31cb1e18.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Xr1vjGbJwxjh8PXsHpBA"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Xr1vjGbJwxjh8PXsHpBA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-07-12 at 22:45 -0700, Andrew Morton wrote:
> checkpatch does not report on context lines - only on added lines.

Hmm, I think I saw it ding this in the past. Anyway, I have no problems
cleaning at lease white-spaces in UFS globally separately.

--=20
Best Regards,
Artem Bityutskiy

--=-Xr1vjGbJwxjh8PXsHpBA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP/7Z2AAoJECmIfjd9wqK0TrgP/2UoTBJzDb1rwy0qnD+Yak3A
yL4Siv7onswxH22GQzEPTbd9mrjAR+UzUGXcU5bmF5is30WSmh4ygeYtfynC2g7A
knnT0C7Q9xHWskqR5fk0ROQa5dTTp41OBQ12n8hKlDD/nIPCwnBHUzfCb/5QZLyv
0okOb4JBo6Xy+6MOJs/Q5INSdZnYxotP0DMaTzMmFbNFCPY3WkAELtIcAb+h4wdx
M6lwAyvVxKePyHGBzRbALuBNq3dRD2UvT5WYncunSDMylMalpiWVCVdoM/iFvUyR
IVyuqU0hhzYJ6+Q3UxmzJ0MP/gZGvWntqtf4Vivlp3WVPcARtgrx4UNyS7lYrgWc
VYJU7sonSc+DQu7sg/dir9LD4N/rRIqQvfrmZLfgxUtxAOO92sGFQus0+O7qtF8b
WsBsG0zhZ8h+ZAAvaXQIYA2nDhLzzEbgXqoW5MF3gYNRFfJ0U+yOdMyxJFoSWRzu
yaSNkbYYP2IbCIdwc6RqHhGPhJJr7Upf9PX/s1NW7jqBxOw2T2RqJ+nwALwfhRTq
sZTXukq9bonNlVL32XatkNsiCkOm9OwQGlp7vaQInR5S+wlRMJx7KzsjtQV06XvK
T9nqDo3i1nRo5NiwicMFsWx90yOOQ7Roki5o4NEWHW06LMtl3s1yTRC/McduMaJi
kkkkX12a2RkoEdot1Xh5
=vWcK
-----END PGP SIGNATURE-----

--=-Xr1vjGbJwxjh8PXsHpBA--

