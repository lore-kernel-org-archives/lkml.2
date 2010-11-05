Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab0KELOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 07:14:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61152 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0KELOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 07:14:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B/vIXj8iv1Q8C8QghiIKUPGrmalGDNYbe3Kwxwfc/SNzmpOeovd+FY4IpkK5dRxeMn
         f4KGGEpaCd2HOV4mVjlbJCPEhaFfTnoye76e5IXBDII2moMAfJWtZdz92eyrKmaqY/il
         0G9aeaAc+CjITDpk1tovJmMh75uJTXkYK1HU0=
Date: Fri, 5 Nov 2010 13:14:43 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: task blocked for more than 120 seconds
Message-ID: <20101105111443.GD3930@swordfish>
References: <20101104155826.GC13818@swordfish.minsk.epam.com>
 <20101104161943.GA6520@arch.trippelsdorf.de>
 <1288891946.2039.31.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
Content-Disposition: inline
In-Reply-To: <1288891946.2039.31.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (11/04/10 18:32), Peter Zijlstra wrote:
> Subject: sched: Fixup cross sched_class wakeup preemption
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Sun Oct 31 12:37:04 CET 2010
>=20
> Instead of dealing with sched classes inside each check_preempt_curr()
> implementation, pull out this logic into the generic wakeup preemption
> path.
>=20
> This fixes a hang in KVM (and others) where we are waiting for the
> stop machine thread to run..
>=20

Hello,

Peter, patch seems to work.


Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>


	Sergey

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAkzT5yMACgkQfKHnntdSXjSMKgQAoOYFAMjyR/bDaUwHmyS7CaOj
olq2k5iWZtzh2p+az/cnsn8exrRooTXon2N/6UF30CMr/J0e/oqr5of2Tfq3wiXj
nw/NHIS/xisJwFvkdZlUbZ3v/n6TGZsodbJjnC0fnWRbQ0Waw5aM/0+nNr1jnqn0
NQ57lRhE2eXtf7bssgY=
=SeBw
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
