Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3AGXAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 18:00:03 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37101 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3AGXAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 18:00:02 -0500
Date: Tue, 8 Jan 2013 09:59:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: paulmck@linux.vnet.ibm.com
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: linux-next: Tree for Jan 7 (rcutorture)
Message-Id: <20130108095959.98d83d91dbd0e9e1ac023373@canb.auug.org.au>
In-Reply-To: <20130107221627.GZ2525@linux.vnet.ibm.com>
References: <20130107142649.c843e0b711532dc3a631e4cf@canb.auug.org.au>
	<50EB252C.4010005@infradead.org>
	<20130107221627.GZ2525@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Jan_2013_09_59_59_+1100_A/HjIeKRa=cWdy3X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Jan_2013_09_59_59_+1100_A/HjIeKRa=cWdy3X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Mon, 7 Jan 2013 14:16:27 -0800 "Paul E. McKenney" <paulmck@linux.vnet.ib=
m.com> wrote:
>
> On Mon, Jan 07, 2013 at 11:42:36AM -0800, Randy Dunlap wrote:
> >=20
> > on i386 or x86_64:
> >=20
> > ERROR: "trace_clock_local" [kernel/rcutorture.ko] undefined!
>=20
> Hello, Randy,
>=20
> Did your build include the following, also pushed to -next in that same
> batch from -rcu?  Including Steven Rostedt on CC for his take.

That commit was certainly in next-20130107.

> ------------------------------------------------------------------------
>=20
> tracing: Export trace_clock_local()
>=20
> The rcutorture tests need to be able to trace the time of the
> beginning of an RCU read-side critical section, and thus need access
> to trace_clock_local().  This commit therefore adds a the needed
> EXPORT_SYMBOL_GPL().
>=20
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_Jan_2013_09_59_59_+1100_A/HjIeKRa=cWdy3X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ61NvAAoJEECxmPOUX5FEr6AP+QH1k/zXyRM/93SicoFMNpAF
FK2v7eyFXCN9PZA8nMCw/xV3OUPySw37XAMhvqiXnWEmNDnePtw7FY5YT7Wuc+9T
d4si4/ainSbVXTO5gigZdr96wN3Xt5IDN3O4J/0rg+ORfwTmwumupen22O7b3MVm
n3fqj2gdVJnHtWvIlotIJg8Oexj6ilrgixuYd+zHujTYbG8rNojfc/IihUdYIOX+
3nVHrRNx0grcILRCxOJnMpISoegX8axN4B82koS4ftRxyjwHwGNoHOVqUaLwjlOb
7v4OpuKWph8AUg5EXzsO4u+4UVcUKJ0FL+uiT6c/LRaB48bJu9pTJdQzgLPptisu
J302WLylvRQzvsv2C6F4Agl8HOTlSpFWeTDNoNlRyx0p/6V33Ah6RerrzdQkyH46
SckZqvWvopDcYH9IvZgjhsnS4yuMKgT+i0QLhKOf1fmeCMu+trSaqzsqJnlEV/Mq
S7Dd6dmLmw929jODWIrVna7aJBAjHc9otgYVvt1ICyWi72Wd1b4AfMWNg5xpplYR
xWLadBMQdE8Nf3SDj+ex+3v9/CPOWY6ByVdRhWC3OYZ3Wi2YckkiWtJcpLXACmJx
6rUwdT/rIX9mhbVqXK9/ipoyS8JFMy0EsB1cAkmQiddU3MlGOqnS9U2POTYPsTBK
AhyB0Ia33jWyVzEMsmqG
=FSFx
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Jan_2013_09_59_59_+1100_A/HjIeKRa=cWdy3X--
