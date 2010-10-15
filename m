Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0JODDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 23:03:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60048 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab0JODDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 23:03:30 -0400
Date: Fri, 15 Oct 2010 14:03:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@medozas.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        agruen@suse.de, davem@davemloft.net, andi@firstfloor.org
Subject: Abbrevieated SHA1s (Was: Re: Process to push changes to
 include/linux/types.h)
Message-Id: <20101015140319.3ddb06c3.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTik+NENndwKFSFQoVAr0qiBWg5HOsQdVPmtNaSjC@mail.gmail.com>
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com>
	<20101014125458.9e51ac58.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1010142324400.31442@obet.zrqbmnf.qr>
	<20101014143723.ffea0d8c.akpm@linux-foundation.org>
	<alpine.LNX.2.01.1010142342400.31442@obet.zrqbmnf.qr>
	<AANLkTik+NENndwKFSFQoVAr0qiBWg5HOsQdVPmtNaSjC@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__15_Oct_2010_14_03_19_+1100_FEdu7shq5C5jB5ZO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Oct_2010_14_03_19_+1100_FEdu7shq5C5jB5ZO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Thu, 14 Oct 2010 15:13:27 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> Extended background for non-git people: git _internally_ only uses the
> 160-bit SHA1 (which in its full ASCII form is 40 hex characters). But
> because that is so human-unfriendly, there are various human-readable
> ways to express it:
>=20
>  - Just a shortened unique version, usually 7-12 hex characters. 12
> hex characters is already unique in practice for pretty much any
> reasonable project, and is much easier to write.

I have had one case I hit where an abbreviated SHA1 (which may have been
only 7 hex chars) was unique in your tree, but not in linux-next :-(  I
think it was unique after one more character, though.   Having this
happen was a pain, because git reacted badly to being given a non-unique
SHA1 to look up.  i.e. it did *not* say the expected "this sha1 is not
unique".   However, now it does, so things are getting better.  It would
probably be nice if it told you the "matching" objects ...

So I would support using (at least) 12 char abbreviations in commit
messages (and any other long lived context).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__15_Oct_2010_14_03_19_+1100_FEdu7shq5C5jB5ZO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMt8R3AAoJEDMEi1NhKgbsdHUH/RcvQ1/FG+YRBmgyFxiQsXgw
CslFBHHlWEUb1dGpYiTA5Z5Hs5HRioX2Ddspj460JBPuX9xBg50cDf5KZwS4sALI
n2QG4WfPhJdgBtuOqf9HykVWq1lG0zcOag7XCj/qMcVd7lAOeY9e3tSZX+xrtlAQ
4bbXOiBUm/GIrLMDF20jEDg3Y5U+ytxzGSc98yHER51RQ0jzxfe8AghEDhrWczYe
8hvm2fhDXzcOrRgCeY1weDhJc2LVPVRt6qFmU9yjC/3kK0jc9a/0C3H/tsqZ79AW
u1W6n4W9/zHdhvs3q2C5j8nwY9dn/NX0lX+DievR2s+bLPJSEf1DUjHKqHhHQs0=
=r7lK
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Oct_2010_14_03_19_+1100_FEdu7shq5C5jB5ZO--
