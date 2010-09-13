Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0IMNsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:48:40 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54247 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0IMNsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:48:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EOdCWa6YATbDh1BJsBUQliQGz1V172GpJ/nnAiK/txd5G1woN0yjS24Wg7dmkpawHs
         NP+aIqJ/hVUDbyWLmGD4pvyn8ozrdUSAOEOlj3PlbDbfiv47+NwX0T5oi2Rs7K+5ov6h
         UumYcvaOgqWdg6LOP5458WMsq3vpVgSk/+9KA=
Date: Mon, 13 Sep 2010 16:48:47 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, Avi Kivity <avi@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [Bug #16961] kernel BUG at
 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1978
Message-ID: <20100913134847.GA5263@swordfish.minsk.epam.com>
References: <EP3NUDNWMO.A.O0.rrRjMB@chimera>
 <0c5PAlgnPrH.A.WOC.hsRjMB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <0c5PAlgnPrH.A.WOC.hsRjMB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (09/12/10 20:14), Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D16961
> Subject		: kernel BUG at arch/x86/kvm/../../../virt/kvm/kvm_main.c:1978
> Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Date		: 2010-08-19 9:54 (25 days old)
> Message-ID	: <<20100819095429.GA5201@swordfish.minsk.epam.com>>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D128221169606214&w=3D2
> Handled-By	: Avi Kivity <avi@redhat.com>
>=20
>=20

Hello,
Fixed by
commit da908f2fb4e783c2a4de751fb90f11a0dd041161
Author: Zachary Amsden <zamsden@redhat.com>


	Sergey
--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkyOK78ACgkQfKHnntdSXjTfYQP/YDtBVVkNy2wz54WrtlNx8Ilc
3D9iWrEj5IIipPa1HUpiKxTMaokSGxKtsB8yDKL6pGT57DHqYZ0GQPBwFGqbKzjF
WqlFLZQgAUkVOdvKIpk4sivan43hV93RCK4E14f4rWliyMI8GVCsvj8I0ahMft0X
xsIOZhi3BfX0qenYyBs=
=iMwO
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
