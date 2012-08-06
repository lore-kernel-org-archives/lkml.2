Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab2HFQEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:04:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59884 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2HFQEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:04:41 -0400
Date: Mon, 6 Aug 2012 18:04:35 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Grant Likely <grant.likely@secretlab.ca>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/dt: use linear irq domain for ioapic(s).
Message-ID: <20120806160435.GA2484@avionic-0098.mockup.avionic-design.de>
References: <1343890270-13007-1-git-send-email-thierry.reding@avionic-design.de>
 <20120806073811.GA3261@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20120806073811.GA3261@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:I7NRLUnt5zNtqViOdTbCc/JmsuM/YVwWbrrVzwksC+s
 iDGjvE/CXH1rEOBlJDdLo9hdTPXAdIr8IOd/W7zCs7x1CsuCvY
 5rqddUvPTNbjX64W64jFB4vnmDsU8BFIajmxfjn8nfBG480hhg
 6lwcmRmT0Cifax2D0l3blI38op7VgwqYj6i7TOkLiPKQiQvab8
 OY0lirVHXXTTEZOZRxA+I/IoHth0YMNSCo1yEMMp33Wnwv+0QH
 6UTyg/KhjpbBAXnMfrsBuUCjBrbcRyGHuoZPmPzMDo+9+0/TLd
 HKHT4Gr+rqwp9kZqYU95gHNu7PQxfllPPyu4mNd6KpA2mtvCjm
 GZVsr7cA3ufVkApy2RIgwUitSlJquQkMHZpMl7uYF7Y32Vs5Nb
 CZP0WzvWbYyUVNjxR2vm3K6q3QkwrompnUNIymNXkaqEBbxh8u
 +3A/y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 06, 2012 at 09:38:11AM +0200, Sebastian Andrzej Siewior wrote:
> The former conversion to irq_domain_add_legacy() did not fully work
> since we miss the irq decs for NR_IRQS_LEGACY+.
> Ideally we could use irq_domain_add_simple() or the no-map variant (and
> program the virq <-> line mapping directly into ioapic) but this would
> require a different irq lookup in "do_IRQ()" and won't work with ACPI
> without changes. So this is probably easiest for everyone.
>=20
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

=46rom a quick glance this looks much better than my patch. This depends
on a couple of patches in linux-next it seems, so I'll have to do some
rebasing before I can test. Still I think I should be able to get back
to you until the end of the week.

Thierry

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQH+sTAAoJEN0jrNd/PrOhzK0P/1rvB4R/KD/e+hOwRimPqtZw
8FBVoLM1NeC25LELVUUc1yDcOB1qlSbspjli/7KwcHTsX/55EPBDYBAvn+V5i6hD
Dayh0Ge16vbIkPOKkuNDL7GkRuxqyHMuhn0DbnT5WXpN1t7YqD56636Ay9x/vXhs
95dmY7lFJBs95YT3F1EpWxVlPAvF8KBF7QI70KVJLgYgUxO5DHgxZjqlTOdyi/4p
bNqnqNrYK5Y0h4QtaM2243dZn3ov7XpexfDgj+lX+X4MZ9BT2jEBd8GiUrKRYqrf
lA/JFOSdpjJbLi1eNuH6NXK2OlmWQ9XaQ78EQ2qfPGBu2F95CIZ/FaSVD3JlelvO
aK7Ae2Khd46+TyMuTOJsjuiFcp5bqbcbouh47thSrt2CtPzH75g+FHrcPQe/UyTB
VulM79KtPjJqfyBUyARq/NtbX6xeumGi3O1snYtq5KsfI9nq+biw5+tMQTs7qTRx
uDx48fEM1hwRHkLa/heheWFeb+L/rqyHPsht9xlbmPGlU9Jr2HfGyH2oAmT57B+8
vJrgTpwiuRvFYuvxb4SK3BVz0N3SS/iofvNHtavbT8+dZAtWPvu/NfKXT2pa7K7j
7/EbjQVjcoxwxh0i5W6gvqr6oiIUzbYVjujhnfmGGfO/lR9R/JynyIGkbQf+vhoB
DL0b+a5dp8vSyZ/FbA6j
=z102
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
