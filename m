Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab1LEV7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:59:41 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:47586 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372Ab1LEV7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:59:39 -0500
Date: Tue, 6 Dec 2011 08:59:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, yinghai@kernel.org, hpa@zytor.com, tony.luck@intel.com,
        ralf@linux-mips.org, schwidefsky@de.ibm.com, liqin.chen@sunplusct.com,
        lethal@linux-sh.org, davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@redhat.com, jonas@southpole.se,
        lennox.wu@gmail.com, benh@kernel.crashing.org
Subject: Re: linux-next: inclusion request for temporary memblock testing
 branch
Message-Id: <20111206085919.c9bf7e6a196774f6860d3699@canb.auug.org.au>
In-Reply-To: <20111205210405.GK627@google.com>
References: <20111205210405.GK627@google.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Dec_2011_08_59_19_+1100_3./VYubN1Bu1=/pA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Dec_2011_08_59_19_+1100_3./VYubN1Bu1=/pA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Mon, 5 Dec 2011 13:04:05 -0800 Tejun Heo <tj@kernel.org> wrote:
>
> Can you please include the following branch into linux-next?
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git memblock-kill=
-early_node_map

OK, I have added that from today.

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

--Signature=_Tue__6_Dec_2011_08_59_19_+1100_3./VYubN1Bu1=/pA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3T63AAoJEECxmPOUX5FE3tAP/i3wQ+YE+tkTBXGilbWF1iNo
F+X35xbzuT9/ScMTd6qBUTS0H76P8cxAHzm6OEBDEgw43rGWm/Nqlk0E9/fZCHEB
9+iKEeFG9usuaKg0wHm4Q64AvF8FuoMHDro8/0zpA8oXnvA+Qu7v1/fJUh/itxA2
mWpeWF9EV3mWim12nic3M3gzhcrj8yezhyWJTEbNa/nMsXHuQ0H1kFLW3VWJDvgj
SWmSSz13x0E44B66vmlYaHSL8tQB6xSk8K0fqt5tn70sB5wM7HYAHBlRPz2x7RXX
nxUjxMv95m00EBnDK2T4+EBxhHti79rQbOIHzlrDPBoZvdgLY5Q/rZqVaAdkWL77
YMGNGKtq1b1Zytqy0k6w58/LuXoaX/SFMnvu/vIHZcLVwQ+0IhM9LffYT+2qMzBQ
Nj5nHVgFmjozdUXf/rjjWDUK+fB6b+v80ul6C2Zwsl1IDRWfPC9a+zS7IX/3ACJ0
eFiQ47iQmmuETXvEqoIk3U4PMEBTzdIga2IF9WG50XfLaCFiltw1Sm+OUGTtzoRH
ls3ZtOGIx+ire4Noa0Xt/l6Xm+rGIPiCpGT03dx7iZl0DJgu8FobrJE3OtBvcbfz
xmtqbqASQKOLNCbatoo1HTLzZuIDtYKWBubtlC7bzdvkRjbQL+KnX+x80V4uzady
pGPuAym5abcDfHgLTCjn
=xgpa
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Dec_2011_08_59_19_+1100_3./VYubN1Bu1=/pA--
