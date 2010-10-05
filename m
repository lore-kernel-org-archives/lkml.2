Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab0JEIiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:38:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45892 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757415Ab0JEIiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:38:13 -0400
Date: Tue, 5 Oct 2010 19:38:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the lost-spurious-irq tree with the
 tip tree
Message-Id: <20101005193803.e805b3eb.sfr@canb.auug.org.au>
In-Reply-To: <20101005070123.GF12267@elte.hu>
References: <20101005141334.6a0f15fd.sfr@canb.auug.org.au>
	<4CAABC0E.3030700@kernel.org>
	<20101005063227.GB12267@elte.hu>
	<20101005174524.b62d14a1.sfr@canb.auug.org.au>
	<20101005070123.GF12267@elte.hu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Oct_2010_19_38_03_+1100_.Pnpi4eHq2j+=jNP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Oct_2010_19_38_03_+1100_.Pnpi4eHq2j+=jNP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Tue, 5 Oct 2010 09:01:23 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> Fortunately there's a really simple solution: wait for an explicit reply=
=20
> from a maintainer before adding a new-feature tree. (Solicite again via=20
> a To: email if the Cc: went unanswered by the maintainers.)

Sure we can try that.

> Could you please start using that method for all subsystems i=20
> co-maintain?

So, to be clear, from the MAINTAINERS file that would be LOCKDEP AND
LOCKSTAT, PERFORMANCE EVENTS SUBSYSTEM, SCHEDULER, TRACING, and X86
ARCHITECTURE.  Any others?  If so could you please update the MAINTAINERS
file as (at my age) I am likely to forget and other may not guess.
Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Oct_2010_19_38_03_+1100_.Pnpi4eHq2j+=jNP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMquPrAAoJEDMEi1NhKgbsfs0H/2K7TJN6vLhocaGuEy6PLM6D
uMzB2GJylwlHa+/c2e4PFgDa92BEHHVuIKrvG0GWeJMSd0h9+eQNULcPRfFzPf6i
3betOsjmtkFIcOfVAkM+XYxxc2736bzTd3Q5jO4NBsJysLa9akALyZoJHKOZM0qz
cSOekeaHPRv8jNHKwFZccdkNP2aau2CA53HjgHcqtiwcE1ReIKkvfQAqW5XfdF6Y
r3/X+nvOdqSKhyrO3RMx8tiqPZ3lKbZPbHIlOFFt/41Xiw87BM+Nbmm0H+aQTgH3
wQ6M0wPfC31fFCMc4pM+5Qet3Wx2AB8MTsC5SXcRZWYhxqwvbt85lnV2KMJIqYE=
=AYU4
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Oct_2010_19_38_03_+1100_.Pnpi4eHq2j+=jNP--
