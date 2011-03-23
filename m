Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab1CWNKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:10:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62548 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab1CWNKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:10:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YVdg/pHF1SFU8koVAHQyXRIsfwCSC8YCHrMdoiA/fbhd7H80WuM5lBGjuD//7AyNJA
         5LLeomeJxSJsJ2EaoABq0DWpkQUdIUOO8z8fFHC5nAmN2Thkg2M4J3xVD+uqsDNukk6a
         VjrwHiL1desYCUrafkp3C48vu5f6m9FxBaF/I=
Date: Wed, 23 Mar 2011 15:13:33 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lockdep: remove unused factor variable from
 lockdep_stats_show
Message-ID: <20110323131333.GA4482@swordfish.minsk.epam.com>
References: <20110323123828.GB4244@swordfish.minsk.epam.com>
 <20110323125705.GA18862@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20110323125705.GA18862@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On (03/23/11 13:57), Ingo Molnar wrote:
> * Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
>=20
> > lockdep: remove unused factor variable from lockdep_stats_show
>=20
> Please use more readable subject lines in the future. I have changed this=
 one=20
> to:
>=20
>   lockdep: Remove unused 'factor' variable from lockdep_stats_show()
>=20
> Note the capitalization of the sentence, the quotes and the brackets - al=
l=20
> which which help readability by structuring/differentiating various parts=
 of=20
> the title properly.
>=20

Sorry for that. Sure will do.=20

Thanks,
	Sergey


--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk2J8f0ACgkQfKHnntdSXjTmNwP8CC8FFs7tIV2r9EGJrCIwDtOY
llkw8JBx+eKaAclB37EYNQxhCB7jOgXGC15FCQhyVKrWozz5pChXu4QVTlzNYsky
SCfavcPTXEVBZRUFCu8so3cP+0uKublCtTwm5Dx8CNN9cXzFbSAXsCaKDQ+Ck3jk
QhURUVV6aN4Mfqqt2kY=
=uG6k
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
