Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab2HTHuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:50:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65484 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab2HTHun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:50:43 -0400
Date: Mon, 20 Aug 2012 09:50:39 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <bryan.wu@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] leds-lm3530: replace pwm platform functions with generic
 pwm functions
Message-ID: <20120820075038.GA20443@avionic-0098.mockup.avionic-design.de>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0095@DQHE02.ent.ti.com>
 <201208200537.48993.arnd@arndb.de>
 <20120820055817.GA17149@avionic-0098.adnet.avionic-design.de>
 <A874F61F95741C4A9BA573A70FE3998F41EF0939@DQHE02.ent.ti.com>
 <20120820073141.GA27645@avionic-0098.mockup.avionic-design.de>
 <A874F61F95741C4A9BA573A70FE3998F41EF096C@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF096C@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Oxtj5JYYc9ewzYRtnzRYtTBvdLQFusfYpGgpFe0HkT/
 allF9eAVP6qb9mC60578CA+xNrxTViES5SsJBj10IvqUE9RqrR
 02f8GFwiNRLttdIxGebUi3y3JNL45wZkpt89Gs/z8VRVxfHFgw
 YNv5Uj6k6VBwLxVMBo01a3h0td8cNgvYZKe8bN/kjV5zg9nXd7
 PHZ/mUuOua8WqR0uyErfiI4+VBtKrKPtqJlHd6bnPYdYE7A5gn
 ITpezlpWVV/MFFehskFxBpZrWFF5ZK9F59BMGs9A8gDuOij10t
 0fd3fDnFKcQ/u8H+ZoWDpceCtqSPLlSjUSHr4fsheuVE5bGFUZ
 0t5c/9JDkFa99CiJ8iyOg0VFQue7nmVIWoXACSfnC/xYejHWl0
 rKP6MD+UjMSGwIOUJOkVCMB0jtCGIvFSgA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 20, 2012 at 07:41:31AM +0000, Kim, Milo wrote:
> > Maybe we should get this resolved somehow in the meantime. Resolving
> > the
> > other issues may take another cycle or two, so you may not want to wait
> > that long.
>=20
> Is that job also including HAVE_PWM configurations?
> Some SoCs still set HAVE_PWMs and codes exist under arch/ directory.
> As I far as understand, new PWM subsystem uses CONFIG_PWM not HAVE_PWM, r=
ight?
> And then will HAVE_PWM be cleaned-up?

Yes, the goal is to remove all implementations of the old framework
(HAVE_PWM) and replace it with PWM only implementations. I suppose we
could in the meantime add #ifdef CONFIG_HAVE_PWM around the legacy
functions and provide dummies in the !PWM case. That might work.

Thierry

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQMexOAAoJEN0jrNd/PrOh/HUQAINn1M1HXqNDcdGm+zS6hNNb
aFy0bCvo0M+SfAo7XOIu8JUAtmvWZqWf14Tzq6lNXYgs9K56UF8RqqcK20XIaM43
YJtFjLDSHcQkmymKUYqQvfmDDxwgJAgTbN2E0a/p2Yoo9PvCJkG8DEgh1+oTI8X/
aroMLX8nIDw7K00Iaf2NcQVwGAdCSQkNmVzgsSdpZ+ukzikCzJ+naqjgtGDlEzIE
sv/7AFlB3L1/oJjIdOgrb80QjZxOnxFk+uRROarpI7hROqQ01GqwmmV9Yswa8bv6
4hdKhThntEIX1YifxYWnZm983n4gu/rHKamwnOkbZaf9FSfAyleBL55HA8IRQfgo
hUb9tANEXGnwIUE7YATSdtmPLuPwR9Cu11ksN2P8S0reu3xS+5pMrFCxRAmpXZOY
QL6FRulSse6Xsin2KCJ7M+Darc6HSH7JKbW0fY1upbbD+RbXZ8bcBb9BFkAmPaRQ
RMrJ8YVjR9CkniQvrJxq43YniHnsIGQHksI3WqjgORlaOkXR6SZLPfu826JEkUHW
s2jW/VCISdOR2zWFAnC0AhqeLAjiuRLx237iS7RozmoJm4x+evXo9TS/bU883bdL
6swi0WGCcYFk05qfanG9Js+uSfIfcQNQDOY1ux3h1LOQgmYTfRNw2BWze1autPjo
Ur9A5YpEZV0GljhyNcY3
=+BXK
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
