Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab2DJPTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:19:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43646 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758798Ab2DJPTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:19:47 -0400
Date: Tue, 10 Apr 2012 16:19:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120410151943.GM7499@opensource.wolfsonmicro.com>
References: <20120410131930.28186.85370.stgit@bob.linux.org.uk>
 <20120410131206.GB31551@sirena.org.uk>
 <20120410142501.6045c6c0@pyramind.ukuu.org.uk>
 <20120410133339.GK7499@opensource.wolfsonmicro.com>
 <20120410144235.1e05efd4@pyramind.ukuu.org.uk>
 <20120410140749.GL7499@opensource.wolfsonmicro.com>
 <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yaap9KN+GmBP785v"
Content-Disposition: inline
In-Reply-To: <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yaap9KN+GmBP785v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 10, 2012 at 03:15:29PM +0100, Alan Cox wrote:
> > Could you be more specific about what this early boot time stuff is?
> > Looking at the changelogs in there it all looks like the standard
> > battery monitoring and power supply stuff that these ADCs get used for -
> > just based on the changelogs there doesn't appear to be anything
> > remarkable here.

> It depends on the actual device but things the like battery management
> are a key one.

Right, like I say that all sounds totally standard and unremarkable.

> > We can't just keep on going round adding new custom interfaces every
> > time someone supports a new SoC - it means we end up having to sit and

> We can't go around blocking entire platforms because of the IIO blob. I
> raised this point with the whole previous *generation* of Intel SoC
> devices about IIO and nothing has been done about it.

Including by Intel, of course.

> Get IIO out of staing and we can look at it, until then IIO is staging
> code, it's not part of the kernel, it may never be part of the kernel,
> and it should never block actual kernel code.

That's not where the rest of the embedded community has been coming from
on this stuff and from a deployment point of view staging isn't really
that big a blocker to users.  We've had a lot of experience with trying
to follow that approach and the results haven't been great thus far.

Frankly at this point I don't understand why we can't just lift IIO out
of staging as-is, perhaps with the userspace ABI nobbled or moved into
debugfs for the time being if that's still a concern.  Alternatively
there is the option of you proposing some other generic framework.

--yaap9KN+GmBP785v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhE+HAAoJEBus8iNuMP3dYpsP/1iRFE12P5ybBC9/bKMs2PsY
KZAADZ6M79UaDuZ6t4hlS5BGSLqSKb7cCeA1Qkzqvts4AfwKruUPpCExMoCL1yKE
dHgl4m0BAGmfcXeDkv5FOMuJxgOojAajvGPsB61JgFIMjE8eYli4nd01VIf+ei0z
axqPeGTnZQexLNvY09kCv4eFOvmCGf3mU3dGnxk6WPQrMZ49hMeVdZFB+CkLMuXv
009/q6sWduyGgv80ntyC99cW5vWuuFG/Hh7JVnkPpQ0f43ATbC+aPMq8nvnxHQua
b7j8K05+EKCFoLWrnooKGLrW1QJRS3cC0ozjEYoMPDVwhgY0luwf+3dp64kF31up
gaIl+ETCW4nVlrxdtbsrXAsG73HFW6RR0QShLXAfd1Uo1g0nzmZHFBJBQdo2mOJP
fXh/h8MP8+8AOd5NZnOIqCSXKku11tCuyAZzx1xTPsWXsg0IZkryL6lV3m5QFOyT
iYE5+gc7IeTJxXvMMgEyaM9LRzXK35n5+i7rDh6YmlKd1OkCa4DX+CBcyVMXJ46V
WsRvQARW0mjYz9JZF1cSfPn0Kee02a6vLNAfWZrwxnFvAnztXjhkRYTF/YWHJMr8
rhsJFQZITqnqzvMwjOKvwspVlWqDYLK3YPozBru8nslkmcpySv9S2+xopYURk5Gw
5S4Z9wTjdbGeiUZVY4JL
=MVFs
-----END PGP SIGNATURE-----

--yaap9KN+GmBP785v--
