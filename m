Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab0JRO4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:56:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44696 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598Ab0JRO4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:56:11 -0400
Date: Tue, 19 Oct 2010 01:55:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 00/20] mm: Preemptibility -v5
Message-Id: <20101019015559.78f20716.sfr@canb.auug.org.au>
In-Reply-To: <20101018112433.556591568@chello.nl>
References: <20101018112433.556591568@chello.nl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_Oct_2010_01_55_59_+1100_sS5b+GtoRrtBdBpR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Oct_2010_01_55_59_+1100_sS5b+GtoRrtBdBpR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Mon, 18 Oct 2010 13:24:33 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> =
wrote:
>
> Linus, Andrew, Stephen, can we add this to -next for .37?

Well it is late (the merge window will open in a couple of days, I
suspect) but this is version 5 of these patches (so they have had better
review than most).  So, if Andrew or Linus want this stuff in .37, I will
add the tree, otherwise it would just be adding confusion for all the
code that will be integrated in .37.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__19_Oct_2010_01_55_59_+1100_sS5b+GtoRrtBdBpR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMvF//AAoJEDMEi1NhKgbsDowH/jih56BkCPCf/Sj3fe51IjSy
KAUXpr9t8auYaMlMs1AzMgPDkuSHYlY4BpauwFUMK+GH7l/UgZMqZWNJ7QIBvPt1
ujDX6UyjsMydxpX4sFxgW+Yn/DNCAjGuC9DiH4kinHeHElqnlW4kAPiEaYK554xJ
uba8MABYn3aROROKG+DwReli/ixxf3YqumafIc973ToY8P9WqdJM6jVVj7CzzRb/
wPf0Q4IGMdt5GADx3EoLLk2HzoQXBl+uur1f+IT/wxl1SOYmKw5LfgRwRw9EwuY3
5/cx4WueSEjMnp7RusqpwLrClhrSPVtzNeN9B1lmSLMjF6NwTlGThHSkA25ViJM=
=o+y8
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Oct_2010_01_55_59_+1100_sS5b+GtoRrtBdBpR--
