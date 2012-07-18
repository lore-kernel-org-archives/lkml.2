Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2GRKQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:16:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36528 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128Ab2GRKQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:16:15 -0400
Date: Wed, 18 Jul 2012 11:16:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: Boot breaks in -next from LEGACY to LINEAR conversion
Message-ID: <20120718101612.GE22739@opensource.wolfsonmicro.com>
References: <20120717185749.GJ4477@opensource.wolfsonmicro.com>
 <20120718005230.GA15680@linux-sh.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k3qmt+ucFURmlhDS"
Content-Disposition: inline
In-Reply-To: <20120718005230.GA15680@linux-sh.org>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k3qmt+ucFURmlhDS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 18, 2012 at 09:52:30AM +0900, Paul Mundt wrote:
> On Tue, Jul 17, 2012 at 07:57:49PM +0100, Mark Brown wrote:

> > -next fails to boot for me today on my s3c64xx based systems.  Walking
> > back to the last time I tried and bisecting likely branches I find that
> > commit 910139 (irqdomain: Replace LEGACY mapping with LINEAR) is the one
> > that introduces the build break.  Unfortunately the boot fails before I
> > get a console which makes diagnosis somewhat more tricky than would be
> > ideal.  Any ideas?

> Does http://www.spinics.net/lists/linux-sh/msg11995.html fix it for you?

> I did Cc you on the legacy -> linear thread, but perhaps you missed it.

I do remember seeing it, it's a big part of how I isolated that this
patch series was the issue.  To be honest I hadn't got terribly far with
the diagnosis of what the actual breakage is, it took a while to isolate
as it had been a little while since I'd rebased through onto -next and
there's no diagnostics at all from the system when it fails.

I tried applying the patch but the underlying code has changed a lot so
patch gets upset, I'll try to find time to resolve them but can't
guarantee when as things are especially hectic right now.

--k3qmt+ucFURmlhDS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBozmAAoJEBus8iNuMP3dtFwP+QGwzapAnTYtXnYR8jpWh1QQ
yn+anNkgN46xZfUz4gRC+4S1Nvx7k8pOAVGzhQgt1ugk8QViwfHB5MeGJxk7+xim
poo/mXy6I5LRdjNXJ++Lw2OwMqslvj5ehro1h3DiBFeJspf88UFGwHA+no0QKhZc
lSs3P7dwtB0tv5IarxjIZnU5nptnANCDfxg/5JnRjKilPoJ3Tt6H0GhaRQa/y0fa
3A2Grm6YLlU1Qzt7SmdE5R0z0uRHEqXyfQL+kNBHHCCP625Ek8AAo/GsTrDeewf1
n+H+UjJPqmvSUpflBxZ3193nCvvaFXlGIK56nGTNbA6Smt0t845cx/Uqfjj+niXy
WTJZjIk4ttwq8DSmnT45pY2J6sI3yMKco0/L3HR/LQ8OyRTPblDEgrojcrS0XlaF
U4nBga+gwu9BW5/1bN78ChIBcvwLEoaT1qYuEC4fY6JJJ00HKhkWtayH6dcNf42N
I7lnqZbVRj8Ir6HGYH6C9mF9YODYGKOWwKlJODxNZZ9adCv+IFjIZ/Bp73jptUAi
s3qL8VVhP8JeD0UBtmbvifk+EcNBYHvCOqoRoa2VrgiGotZDGmK799PP6LJXixfH
YBpSuUY8uzYfWo0OtCRnBT2yeGcwDNSGQTSYRE/ZoKanpsp8AUhLfWi4QpBK+9PW
g0a62bhrXzwTdR3t+qUV
=fUhP
-----END PGP SIGNATURE-----

--k3qmt+ucFURmlhDS--
