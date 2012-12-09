Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686Ab2LIXEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 18:04:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47455 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493Ab2LIXEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 18:04:50 -0500
Message-ID: <1355094273.20838.79.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH -stable 1/1] freezer: PF_FREEZER_NOSIG should be cleared
 along with PF_NOFREEZE
From: Ben Hutchings <ben@decadent.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sun, 09 Dec 2012 23:04:33 +0000
In-Reply-To: <20121207144922.GB6478@redhat.com>
References: <50BF9CC2.7070705@canonical.com>
	 <1354762294.17107.157.camel@deadeye.wl.decadent.org.uk>
	 <20121206124201.GA30705@redhat.com> <50C10391.4040903@canonical.com>
	 <20121207144901.GA6478@redhat.com> <20121207144922.GB6478@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-lwf2eUpRdQD4cvvrAWVw"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lwf2eUpRdQD4cvvrAWVw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-12-07 at 15:49 +0100, Oleg Nesterov wrote:
> This patch is only for pre-v3.3 stable trees which backported
> b40a7959 "freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD".
> v3.3+ doesn't need this fix.
[...]

Thanks very much, I've added this to the queue for 3.2.  However, in 3.2
PF_FORKNOEXEC is cleared by the binfmt code and not in fs/exec.c, and I
left that as it is.

Ben.

--=20
Ben Hutchings
It is impossible to make anything foolproof because fools are so ingenious.

--=-lwf2eUpRdQD4cvvrAWVw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUMUZAee/yOyVhhEJAQrsxQ/5AQ9hxnttNvtenEJUUEJqFDKBMYJ7NcS6
C+Cwel9HBmUbQTaIVXPs6XmaOo2+NV+ulGayjKWOiyO9HOAoBdYptOgy5OqhsMAL
682Vksy6jiz2YBWrqd0c7EFL3nTkHnk0ESx58Y8ejEnEGTwKGBBUzY3+q2zSCLWq
9rsMYA5+vS8GVQo3S+PevWIIRZTpshHw9SwqMM1+80qu9fLFjzRVhYtFHy7tBaDm
mcyiGcA7NCMfD7XPEhsQK7i67GMfKm+Ql+pcPW4aV2vRsuk9zWrnbXBS34+/ixxi
GbR6K5DG+yfpjlX+5GFqdNSt/CaH83lCGtZUgUZge17EdnVJTx7eZOmjzisLJpF0
i5fxEm+UmvRDGzuGHQoYFyTjXmYjHUGaHZ+wOZPIkaInwKfVMD4v3zxE5A0D8iCD
8t1MS6ZZEda6hKUf8zIeF2Xg32ELz5xM/uXxcqhFjQzXErdz41aWQrbZc2kJgFJD
IP/sHdX+3LAQ/RdfqvD6PxCwpoPVlbq1bKKo9Z/qPcE8y4AJx+GJ6rmDLFFYxD+C
k9w0jGuJrfyFLQBxsF4U/W+nUsKUSUtY+hLDrzhsBc84/8jNQOtl8OEABfLrscRi
rnfWf9LW3AuRxdfNGbuNGrAAjX5aOqRXst3Q6Fn8m0itygvoYR5CRQvKVcK8b3x6
6m73jGkeUiY=
=Y9zV
-----END PGP SIGNATURE-----

--=-lwf2eUpRdQD4cvvrAWVw--
