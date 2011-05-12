Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab1ELAwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 20:52:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57609 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab1ELAwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 20:52:08 -0400
Date: Thu, 12 May 2011 10:51:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linaro-dev@lists.linaro.org, Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 0/5] Basic ARM devicetree support
Message-Id: <20110512105152.8c6d9b67.sfr@canb.auug.org.au>
In-Reply-To: <BANLkTi=yCmxgv1fQKRJSZK3FkkRwjS2r=Q@mail.gmail.com>
References: <BANLkTi=yCmxgv1fQKRJSZK3FkkRwjS2r=Q@mail.gmail.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_May_2011_10_51_52_+1000_9Ul4Mb69ecP/CJqS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_May_2011_10_51_52_+1000_9Ul4Mb69ecP/CJqS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Wed, 11 May 2011 22:44:49 +0200 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> Right now it merges cleanly with linux-next and the resulting tree
> builds and boots at least on qemu.  Unless you really object, I'm
> going to ask Stephen to add the following branch to the /end/ of the
> list of trees for linux-next so it can easily be dropped it if it
> causes any problems.
>=20
> git://git.secretlab.ca/git/linux-2.6 devicetree/arm-next

OK, given Russell's qualified agreement, I will add this tree today.

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

--Signature=_Thu__12_May_2011_10_51_52_+1000_9Ul4Mb69ecP/CJqS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNyy8oAAoJEDMEi1NhKgbsBn8H/1J919K+uStjAoDyHC69kmbW
pOQsO5XWT8LVj4Q6rwG6t4u1kbTL0pIVe0aX2YKBLB6/GYUeEaTNs0A+9NlzNSBo
LESBu261BkVih/P1kX99ml4p4VHlPlkdfD70c+H7p8qwt9/kMclf/mtwKbGUpxeV
MO0RzGot8Tbes49LuPNDd5cftg2BwRf1tEsMJ/N//klzf73d7DVbWB+8Az5rlhql
uJXQvSicDZGsfmSs3cAsk7wkR+zFGybq/ae3o1bMmXOuPBNbUBFT3Nk7l2zbdE7d
R4BFeKZreuntpb+0L15x2XKzre3y3cS3ysCUasSbUdfe9UZ1CVeEfz+OaLZVCLg=
=8a2A
-----END PGP SIGNATURE-----

--Signature=_Thu__12_May_2011_10_51_52_+1000_9Ul4Mb69ecP/CJqS--
