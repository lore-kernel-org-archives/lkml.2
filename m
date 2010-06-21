Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0FUGFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 02:05:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52393 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab0FUGFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 02:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Wn+9IbOe0xD5MoCuVtuUp0fuPF35hXmI51WpqQGHiMjkR6NSq8GktU/249uAxurL0t
         e9oaPLjKWBh097nU9vdJkQhDQeM8qQoUrLFDKJTWnLeGWoPxr7fj2jCLJGo48oRFIPla
         gvdlp/ac5J8o91yJj+WIjGODeh5LhrnorYn1M=
Date: Mon, 21 Jun 2010 09:08:47 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [Bug #16248] inconsistent lock state
Message-ID: <20100621060847.GA3965@swordfish>
References: <lc60d4toGTL.A.QzD._LpHMB@chimera>
 <W8JfMs9cZw.A.b_D.HMpHMB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <W8JfMs9cZw.A.b_D.HMpHMB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (06/21/10 00:17), Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D16248
> Subject		: inconsistent lock state
> Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Date		: 2010-06-15 11:24 (6 days old)
> Message-ID	: <20100615112434.GA3967@swordfish.minsk.epam.com>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D127660087625903&w=3D2
>=20
>=20

Hello patch fs-fcntlc-kill_fasync_rcu-fa_lock-must-be-irq-safe.patch added =
to -mm tree.


	Sergey

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkwfAe8ACgkQfKHnntdSXjQVQwQA4ZpN8gLumDFIYBcHiUFj7DQc
Eo27mdcTyUlb1Vw4b1jue/fMcby2be+GU4KUrH7GZLiM0YOF7kv5fk5ti9AH4Q0B
6oa314Gcm8rfqvLb8DLQhowWqAOvRwYEvV+SXXsDNI8kfr6IDT5BgtnpA+XTTAAc
4VCAf6JiUoOFW0kl5/E=
=FJqb
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
