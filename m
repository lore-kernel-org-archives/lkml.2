Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab0I1TEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 15:04:09 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60769 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab0I1TEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 15:04:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k7d3PATREYwvLcWvBOH9vw50HDA/wqyq1AkLRhHHC8gsdZR1UwbcBViQltbYF6UdlM
         kYQhxoHr4+/VevNziUrOmYPJC1VGzkVbSj0NkO6frh4RhpnwqH4xQo+B5irx4VXtKKXU
         AZ3HKnK/tS6SGnpwx1gHnUgFXfB740GcRoMSA=
Date: Tue, 28 Sep 2010 15:03:58 -0400
From: tmhikaru@gmail.com
To: Florian Mickler <florian@mickler.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.6
Message-ID: <20100928190358.GA24303@roll>
References: <20100927003608.GA20395@kroah.com> <20100927163208.GA4892@roll> <20100927215135.3d11d587@schatten.dmk.lab> <20100927233956.GA15705@roll> <20100928083505.0a808ffd@schatten.dmk.lab>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <20100928083505.0a808ffd@schatten.dmk.lab>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 28, 2010 at 08:35:05AM +0200, Florian Mickler wrote:
> >=20
> > Here's a graphical example of just how wacky this is:
> >=20
> > http://yfrog.com/6lloadbp
> >=20
> > In this image, the dip down to less than 0.5 after the 18'th is due to =
me
> > experimenting using the slackware distribution kernel (2.6.33.4) after I
> > finally noticed something was amiss. The sharp rise afterwards is due t=
o me
> > first, building 2.6.35.5, and then afterwards, using it. To be perfectly
> > clear, I've previously used 2.6.34.2 and did not experience the problem
> > there either, nor is it in 2.6.33.4.
>=20
> What load figure are you basing your observations on? The 15 minutes
> average should be the most interesting (sampled at a 7 minutes
> interval...)

my observations are based on letting the machine idle immediately after
bootup. I monitor the state of the machine using a program called conky,
which I have configured to show disk I/O, cpu use, swap I/O and among other
things, the load average. Immediately after booting my loadaverage tends to
peak at about 2.5 to 3.0; on a working kernel this eventually settles down
to 0.00 to 0.05 in about ten minutes. On kernels that exhibit this problem,
it doesn't settle lower than 0.3 and is much more likely to hang anywhere
from 0.8 to 1.2. In fact, if I give it enough time it'll raise and lower
itself constantly without any (visible) work being done. So basically I boot
the machine and go get a drink, come back, and if it's been ten minutes,
there's been no disk IO, cpu use, or any other activity recorded and it's
still above 0.3 something's not working right.

At least, I think that was your question. If you're talking about the graph,
I merely posted it to show that I've been having this problem for over a
month, and it's demonstrably causing very inconsistent load averages. (Which
is why the graph isn't anything close to a line, it's a mess!) the graph
takes a reading every five minutes, if you were wondering about the sample
rate.

If that didn't answer your question I didn't understand it. :)

In other news, I'm in the process of bisection but keep having to skip
bisects that have compile errors. sigh. still at 12 hops, somewhere around
five thousands commits to check.

Tim McGrath

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTKI8HpEncCrqzVruAQJ2KAf/Uxz6a+US7CCRapsWL9dBbqKTIvutk4lL
veUAUH636AlmaB6CmmE/hw+WFyARVJfPHEDIrNRTYsaDKU3lozSEtHmgscaRYa3t
S050x1e1asEWI3EORxkS9Nj1Nbpg0GE3YATpbvTUvZI7IGUGwgBks+4gw1uFwvaz
r5YBF1llz+mK8o7NOLj0jl5q1ePW36CJoUjlPvfivF0GT/yTi/M4hEOvVIHc2C5+
l5ouozxT9OV9+nMgKfpUyYjuMyVsC7uy/1vDGsyEPosyd1FKrv3lsswEyacP4mM9
9iOEFPjjf+vKSJSraGi3DwpqkhPXjDt5r8RNJJ894MzT82xdRcKPFw==
=pssu
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
