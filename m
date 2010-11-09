Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0KIUsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:48:30 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42232 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab0KIUs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:48:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tvD7ykEW+Uozku9a0rh7V7M+OyVDWDjTzFXChpD0sMuykCoHAgiA05FyRiV+Zt5DLS
         0UHFWLfRoTj5iKx/m4m99Q0IJpOzA7AGWvJA6EGKbfrrbkHyTBAFPlONbtaKxw2jUtO6
         st8MYeAyzHJdZ4s+wZzgFkHmBRcATYLq3ALXs=
Date: Tue, 9 Nov 2010 22:48:14 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH] ioprio: rcu_read_lock/unlock protect find_task_by_vpid
 call (V2)
Message-ID: <20101109204814.GA3937@swordfish>
References: <20101109102124.GA3916@swordfish.minsk.epam.com>
 <20101109201557.GS4032@linux.vnet.ibm.com>
 <4CD9AD22.9030006@fusionio.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <4CD9AD22.9030006@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (11/09/10 21:20), Jens Axboe wrote:
> > Thank you, Sergey!
> >=20
> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >=20
> > Jens, are you willing to take this one?
>=20
> Certainly, thanks guys!
>=20

Thank you,
	Sergey
--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAkzZs44ACgkQfKHnntdSXjQJcgQA3XcPV0Vc5EjbhiJKZtTghQjC
nOJAAQ6OYy/1zlSHTntQEUnkofZeiIFUnT/QqfYHH0od69xzXAfs6wnjjJVx6AWl
ll7Uh5pPrYqNqY0diPKQ14CFiXi1DswgTSp7Z9QCk5/Z7LMdtG+mkAHV8BpBV9s9
wsJTpmW+oI5Xsj2YXSs=
=IzsW
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
