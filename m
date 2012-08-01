Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2HABUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 21:20:14 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35212 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab2HABUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 21:20:12 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: NeilBrown <neilb@suse.de>
Cc: "C. Schmid" <christian.schmid81@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: Complaint - pid-owner Support Removed (CONFIG_NETFILTER_XT_MATCH_OWNER)
In-Reply-To: Your message of "Tue, 31 Jul 2012 12:41:21 +1000."
             <20120731124121.5fe10478@notabene.brown>
From: valdis.kletnieks@vt.edu
References: <5016DEE2.1060900@gmx.de>
            <20120731124121.5fe10478@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1343784008_2037P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Jul 2012 21:20:09 -0400
Message-ID: <62567.1343784009@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 209.85.213.52 mail-yw0-f52.google.com valdis@vt.edu 4 softfail
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.5018844B.00A6,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1343784008_2037P
Content-Type: text/plain; charset=us-ascii

On Tue, 31 Jul 2012 12:41:21 +1000, NeilBrown said:
> On Mon, 30 Jul 2012 21:22:10 +0200 "C. Schmid" <christian.schmid81@gmx.de> wrote:
> > i want to complain about the removal of the --pid-owner Support for iptables.
> > As far as i understand it this support was just removed without replacement.
>
> Yes, 7 years ago.

> "Unfixably broken"

Even *before* it was removed, it declared itself "broken on SMP" (which is a
good hint on exactly *why* it was unfixable), and why it's not applicable to
most modern desktop systems anyhow - even an iPad is a dual-core.

And to be honest, the "Linux only cares about big iron not the desktop" is a
total red herring - if anything, many laptops *are* essentially a single-user
environment, while big iron boxes are even *more* concerned about per-user
issues.  I just checked one of the compute clusters across the hall, 1100+
actual users defined.  How often do desktops/laptops have that many real live
users?


--==_Exmh_1343784008_2037P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUBiESAdmEQWDXROgAQIMyw/9GgjLziBYJNoadMGOvDkbeBtpTHZL+qQR
6ZhmsNtGVwH6A02eIF0JVMyfNxUuTVIRD5BH8LcUU+aYG5wbvieT3KjGrZSNdXMk
0FdzHanE8eazx+/9FTEQomn9GsGK3ehnuZRhyg3VUtupdyAPJ6RiKtGgXhGtQHr2
O4kBnS0/FAXNZOAHnzfL07f7q9NFCij4ofCG+WXdAtqs0nu3Zkogy5RafuwsR+kP
YCNMLkwyuIorcAQZZXwekcDuzM89qCaVx/zbd9alohBRNEBOMJqD4C6B75lwcv81
QJUvyW5z16Kj6CEduvL/N4TPvyf61mMVlhZWwdpKs8xrKebEDAK1BltCWgByoxR7
cRTTdCFYO1vAQq00ZJ+CeiWDJwwQ+Tmu54FnyX+E8Fo6V7A9r7RLltB4ZbOdkFBm
ocuwUEpsOApzFxtoCr0VnFfBpHsL8czYgkhgq9UsM4JX3rlMOskn4F5ONGqee0UY
fXIk/OM1FkdgfxUMdC0uX3ANZffp0WS0FDa45qPq1UwnmwWIJUNUm98ILdX0vSVZ
TvTqQTIH7p+ihR/9KUE1yEtp5qis1/fZO0lFNZ+ZTaK/nol4fdIQAejKEm7rHAjr
pn7C/in7ZXKpKPUvIN8qU3pWPpFtwjZ9PcI5UuBQaZYyUjla5yovSpWRBoO00J5L
AJCCt4Hypys=
=OdBt
-----END PGP SIGNATURE-----

--==_Exmh_1343784008_2037P--

