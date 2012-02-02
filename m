Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab2BBXfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:35:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:32899 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab2BBXfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:35:07 -0500
Date: Fri, 3 Feb 2012 10:34:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Please add irqdomain branch to linux-next
Message-Id: <20120203103452.14370a8f0a97199094770443@canb.auug.org.au>
In-Reply-To: <CACxGe6sTO_Jy-vecKS9SoVs55ZA8BMc+O0NODLdq6KvkcbPByg@mail.gmail.com>
References: <CACxGe6sTO_Jy-vecKS9SoVs55ZA8BMc+O0NODLdq6KvkcbPByg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__3_Feb_2012_10_34_52_+1100_fKru8lp8BGlZ76vC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Feb_2012_10_34_52_+1100_fKru8lp8BGlZ76vC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Thu, 2 Feb 2012 14:10:31 -0700 Grant Likely <grant.likely@secretlab.ca> =
wrote:
>
> Can you please add the following branch to linux-next?  It contains
> the majority of the irqdomain rework that I've been doing.  I'd like
> to get it marinating in linux-next early so I'm sure it will be ready
> when the v3.4 merge window rolls around.
>=20
> git://git.secretlab.ca/git/linux-2.6.git irqdomain/next

Added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Fri__3_Feb_2012_10_34_52_+1100_fKru8lp8BGlZ76vC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPKx2cAAoJEECxmPOUX5FE4o8P/0HZrDu7S1mFn1wx9hmqg8ks
LbRdBDA2LzuXcAHdwNahlVDzj4v+YnFzna2TgJl338k8+O4xo3C7Ya2wNanxkP7z
l0ZPXE3KkiDOfcFOoYNVncKmBZNg1ioZFjXpsaxkeP6TqiVaB5O4O/BQizUQS2Pi
3D1aT3RjJM6d1eivQsYteoXVTRD4tBAofuZCwtY5502Tj2bTBwcvJNPhl/pYm9ux
UTUtZeLtc9XmIii44to5xCS49z6v09BN/fVED16XvSWxkog21dL7TGGN3xvBem3n
OvofQVnomcxkbqaJ3n6lv8kxYfm5ITbaTHrI4q32nFmh1oTMhcmsRzpHUtztPSCB
gdYEJETKqJpCZoH/32h7SPlvF+wau6U2/+KZPfT0pCa0T8zmymvfPXmJcNqIREa8
kSN9GcIEcM8NXONh2qP5yLmq2vFJzJJYmdMASS2dODCzNj2mh+sN4Fad50uktopf
s+o1CpQw5b4hjC0CKJcrrjs6i4lP/0yET3SijEitht1/aV9OhwcwkpMv5RlxCctG
jphQdTwYQ7AbMKZ3W1eIP9jg5bz4GKb78EX37nXprf5ot4qFV7BnhR96VVwPmIUi
FaacSRIjZHHc9d+STjmOgMJz0tZBYkgNpHzIIJqHnMLCzSJwTkNGLxRyOc4DF0qC
rmkdObu6wIRLD/K/POr1
=4jmT
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Feb_2012_10_34_52_+1100_fKru8lp8BGlZ76vC--
