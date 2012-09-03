Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab2ICOUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 10:20:39 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:33960 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756477Ab2ICOUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 10:20:38 -0400
Date: Mon, 3 Sep 2012 17:16:19 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: balbi@ti.com, Hein Tibosch <hein_tibosch@yahoo.es>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 1/2] dw_dmac: make driver endianness configurable
Message-ID: <20120903141617.GM3147@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <503A8CAE.6050606@yahoo.es>
 <20120827070323.GC28721@samfundet.no>
 <503B342C.9060300@yahoo.es>
 <20120827111431.GA27868@samfundet.no>
 <503B8B26.3050205@yahoo.es>
 <CAKohpo=ALUNOnQdQjNd1Y2jtocxjixKCiBrRZp8qGErqg1LSKw@mail.gmail.com>
 <503C6B67.2010903@yahoo.es>
 <20120828073858.GK27166@arwen.pp.htv.fi>
 <CAHp75VeFDRYXuY0bkry-Leo-uGqEGYBm46wKfmj_Vxt_m3KO7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g6DVDhPhk1bqxDrC"
Content-Disposition: inline
In-Reply-To: <CAHp75VeFDRYXuY0bkry-Leo-uGqEGYBm46wKfmj_Vxt_m3KO7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--g6DVDhPhk1bqxDrC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 03, 2012 at 10:50:44AM +0300, Andy Shevchenko wrote:
> On Tue, Aug 28, 2012 at 10:39 AM, Felipe Balbi <balbi@ti.com> wrote:
> > Can you not read this from any internal register ? Synopsys generally
> > adds a set of read only registers which we can use to guess which
> > features where enabled in the IP when configuring it with their IP
> > configuration tool.
> You right. I have a patch to support few options like that already.
> However, I can't share
> it yet by some legal reasons.

fair enough, in that case it'd be best to hold this patch and provide
something better later ;-)

--=20
balbi

--g6DVDhPhk1bqxDrC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQRLuxAAoJEIaOsuA1yqRESy4P/2cJ/Jw0Tly5SuIVXhAyV/bP
QhmQ+MVIfFqPGNSPPi8SaHS2ZFnz2xQRMHaBhdoiFPR4eN8B65w5cUg4qrMn7Xz1
8wPATkKWfADi+JAOo/XNtDmSGospfEFi26BmKdLmBs7qgj2Hn7qlnW9mX6Dvd/za
m2OIq7LEGGJiQexivaZcPLHgYhgExnFznlG4f7or7mXL91Y/iDH4EstkA7QoO0d6
mCx/3nxHF4DgUNHSPTgcckD24NQx+AmixK/6bTqSd3pDQIOnoCzwnVKHFohaXtCW
N64woKxcLC2scKJ0YMueYxbItJGC3IFzq990WtZjShN1HU1McZNdqjJ8aPT5McGF
9tlSeOt3UI/IJTm2nhduoesdCpab0ygW+XOMaEk9HFldc3wB8+SiLLsBEYbemflT
Vl8Hf7pH9h8sSMYh7si31bMirFiSqpO7Fn+j0l2aHrzFEAwLXXbXG7SHg4CnUNLF
m4D0Ob9cbA4tC0LAc6ZOyLV1S9dcMu7RtjtXP4j+OUQyJ1VQnAW/yiP86HX9Gdq8
OVKHJT8kLcjSVX7FTommfMB6zrcvLqPpp+ALCV0LD1z8sJGFdhdbeov8swQA80B/
s4ZBNGmIXUAe5uLqvjlpvmIdXtXO+GyZjKk1cHs1ZInalovN4jQAQa/VZXWlMweU
dTMO4SK89vanPAtLfrJx
=XGFF
-----END PGP SIGNATURE-----

--g6DVDhPhk1bqxDrC--
