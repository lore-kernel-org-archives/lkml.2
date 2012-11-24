Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab2KXPZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 10:25:33 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:38600 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2KXPZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 10:25:32 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Nov 2012 10:25:32 EST
Date: Sat, 24 Nov 2012 09:25:15 -0500
From: "W. Trevor King" <wking@tremily.us>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Arend van Spriel <arend@broadcom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Streamlining Developer's Certificate of Origin, Signed-off-by tag
Message-id: <20121124142515.GA26479@odin.tremily.us>
References: <CAB=NE6WTFv80w6bkQNqaAG69CADmdiqa-tLKD9s=h_p+1D92tQ@mail.gmail.com>
 <20121120211634.11513416@pyramind.ukuu.org.uk> <50ABFF4E.2050101@broadcom.com>
 <CAB=NE6UnA2o7ur+0WGouJR984LqtdTYey41XzQCvAw1djhkOkA@mail.gmail.com>
 <20121121001043.7e1a68df@pyramind.ukuu.org.uk>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=DocE+STaALJfprDB
Content-disposition: inline
In-reply-to: <20121121001043.7e1a68df@pyramind.ukuu.org.uk>
OpenPGP: id=39A2F3FA2AB17E5D8764F388FC29BDCDF15F5BE8;
 url=http://tremily.us/pubkey.txt
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 21, 2012 at 12:10:43AM +0000, Alan Cox wrote:
> > Not just a separate document but project / github / whatever given
> > that other projects are referring to it now, and we stand to gain more
> > in the community by streamlining it more and making it ubiquitous.
>=20
> Cutting and pasting it somewhere works (subject to whatever licensing
> it may have itself), as does having a list and a location for a copy, but
> you still want it in the tree proper.

I'm transitioning a project to the DCO-1.1 and trying to get its
licensing straightened out.  The DCO-1.0 [1] and DCO-1.1 [2] commits
were both by Linus, but lacked SOB lines in the commit.  The initial
proposal was also by Linus [3] (and this initial DCO version is what
was committed in [1]).  However, the OSDL (where Linus was working at
the time) seems to claim copyright for itself and claims
CC-BY-SA-2.5-generic [4].  Strangely, the DCO-1.1 text listed on the
archived OSDL page does not match the text of the DCO-1.1 text in the
kernel tree (the differences look minor to me, but I'm not a laywer).

So.  What license is the DCO distributed under and who holds
copyright?

Cheers,
Trevor

[1]: From: Linus Torvalds
     Subject: Start documenting the sign-off procedure in SubmittingPatches
     Date: 2004-06-01 19:13:52 GMT
     Gmane: http://permalink.gmane.org/gmane.linux.kernel.commits.head/33254

     ChangeSet 1.1726.1.148, 2004/06/01 12:13:52-07:00, torvalds=E2=80=A6

[2]: commit cbd83da82b15292337ff2b71e619c9a3a95f6d80
     Author: Linus Torvalds <torvalds@ppc970.osdl.org>
     Date:   Mon Jun 13 17:51:55 2005 -0700

       Update DCO ("signoff") rules to 1.1

[3]: From: Linus Torvalds <torvalds <at> osdl.org>
     Subject: [RFD] Explicitly documenting patch submission
     Date: 2004-05-23 06:46:29 GMT
     Gmane: http://article.gmane.org/gmane.linux.kernel/205867

[4]: http://web.archive.org/web/20070306195036/http://osdlab.org/newsroom/p=
ress_releases/2004/2004_05_24_dco.html

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQsNjJAAoJEEUbTsx0l5OMjO0P/iW2OxRcpp3g2JGqlgLkgrwb
Y2ExKlqupZueTmKGK4bFkdjjtl3jaaWlTjqn/WtYAi4SO1ZoZuP/8kMCGSdZ6IqL
BovdxFBU0fkwENuSGW2YzzgBH7cbcTiwQWhMAmr09GfJcTXT8BYS4B+638jl7Z0M
JQYqMpoIv/Kg/pfAi7bEqQ7SfpgGdLrHeLGeVYvW+gB7U8UpL7HOSl+uXJSjsNU6
sEk3YUBljmAR9/xi4vItVwCqDR0V9pCBjaA/57x5EF6owWvCUHYtZ048DHnOoNjE
P6eAAVVZjpNe+chv+WSsNUaGsk6G0C4aEKSbz6F2OHi84TC5ZHvu5Al+cwKs+b0D
tB5/eaJbrEFLUB57yVQ3ONQo8iBMk8UX01fwosVKFeZ40FELHyyTW5nQqpFicUXN
An/jFo47G6q6/Bpr+rF7xRDwL3lesbT9pjXWWkHPxH5kzxX43KLZFikOseUm9oYf
kAxWziZrX/irTZB615W8h93vnPm5t20Ekd0900zmBaQpwPbbeyYbsnsj3POhFbEJ
Vww2ZR3IfDwjIYk3Zfa4SZNOV8Hqi5w33qXyXFI0mUgE/yNGadH5+jUD20haV6xi
+xJrxeseWhB4k3XKWZ28Bd1GqDoBil+FYmieORIOZCzhLp2e+Fxh1jPzkrKrZ8/g
NxgvGL5mcAk708eNCV4b
=gj5j
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
