Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2GEMCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:02:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35540 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276Ab2GEMCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:02:18 -0400
Date: Thu, 5 Jul 2012 13:02:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        mathias.nyman@linux.intel.com, mika.westerberg@linux.intel.com
Subject: Re: [PATCH] irq_domain: Standardise legacy/linear domain selection
Message-ID: <20120705120215.GS4111@opensource.wolfsonmicro.com>
References: <1341487159-3919-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CAHp75Vesp7KrYvQrNXK=fGOH5y+jk9AMHVJkGyu8o+72F9LSrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tTvAEuyWWbMF5UF4"
Content-Disposition: inline
In-Reply-To: <CAHp75Vesp7KrYvQrNXK=fGOH5y+jk9AMHVJkGyu8o+72F9LSrg@mail.gmail.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tTvAEuyWWbMF5UF4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 02:43:42PM +0300, Andy Shevchenko wrote:

> The issue is in plain array of the numbers that are assigned to the devices.
> Somehow looks better to have real namespaces, or even hide irq number in the API
> struct device, request_irq(), but keep reference between driver and PIC via some
> object.

> So, given solution just hides an issue, but doesn't resolve it fully
> from my p.o.v.

This is unrelated to what you're talking about.  The devices concerned
are mostly MFDs which use their own interrupts.  Where other things need
to use the interrupt numbers then legacy mappings should still be used
and IRQ domains have no effect at all on the situation.

--tTvAEuyWWbMF5UF4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9YIjAAoJEBus8iNuMP3dg6wP/i6SOms/GhpLNmUzyIyEoKi2
Kb6130iUKz/kUEdTym+wCyDleKGhAGq4JYmfcjCbanTyzLitTIqG0XlFvEph3gmV
PJMCsM+dWRpSWOXA3kCRPwG7Aa14GY/ah6N4FqDGP61aOrMM5VyaD1D8c55KOSxx
o9+x/yoH5OxEtWGfIoa9aAaqX+XGSdpXQpSc51YtpWeaEk1Pj31Qxft+6ayBs/yx
MGt+UM4MdxYLk5SOp4K96KyHtpaK96JkGdGJt0aRSQ/2fu3vTihk0xO05ew8DMsq
vmGHL6YDJNbg/iEKnPLqb0L1/J6ciiRkO/jtQhkdnwm+zOApsdrfnydNMRGBn0j4
n0OlFOxL7PfIV5tEodDQhvpGBZN6kQzHdEGvZlkWg/fMc5o7ORRHURLBrPFbQyXU
S+IglnKFD68E85bRENSxuiMPefmnEQf55X5ERAaO0bJa7RuWFZwxAH9JPEdjmXYI
L3em9cQTplTv0LJPqD28hBJCCdd8O/aL3OkLcBoGqEgd/NvqQfCjkCUhzE40lusn
g+GM/ZQWuvLg6S0NQTQjk2PednJA1pckPZnl6+xoCvvXKW3Zmz3FklMns7aeQ/e1
Y15dpzHTC1d2z1w0ceWl7fZ8ZLiDaqs1kxN2JuinLjLE4plevtJu7m+KKFFFdx3X
7MIIMxu8fnH0UFWe+4AG
=JoDt
-----END PGP SIGNATURE-----

--tTvAEuyWWbMF5UF4--
