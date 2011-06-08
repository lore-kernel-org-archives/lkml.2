Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab1FHA21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:28:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48568 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758149Ab1FHA2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:28:25 -0400
Date: Wed, 8 Jun 2011 10:28:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, bheglaas@google.com, monstr@monstr.eu,
        tglx@linutronix.de, bigeasy@linutronix.de, linux-pci@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCHES v3] pci/of: Generic PCI <-> OF matching
Message-Id: <20110608102814.45c78237.sfr@canb.auug.org.au>
In-Reply-To: <1307491565.2874.173.camel@pasglop>
References: <1302495170-973-1-git-send-email-benh@kernel.crashing.org>
	<1307426323.2874.157.camel@pasglop>
	<20110607090559.149f611b@jbarnes-desktop>
	<1307482663.2874.171.camel@pasglop>
	<1307491565.2874.173.camel@pasglop>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Jun_2011_10_28_14_+1000_FKGpw+nwG4pLPa3J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Jun_2011_10_28_14_+1000_FKGpw+nwG4pLPa3J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Wed, 08 Jun 2011 10:06:05 +1000 Benjamin Herrenschmidt <benh@kernel.cras=
hing.org> wrote:
>
> On Wed, 2011-06-08 at 07:37 +1000, Benjamin Herrenschmidt wrote:
> > > > No significant changes (other than a rebase) nor new feedback since=
 last
> > > > time, I've also added a few acks I got. But not worth spamming the =
list
> > > > with a re-post.
> > > >=20
> > > > I'd like this to go into -next now so it can hit the next merge win=
dow,
> > > > unless somebody objects.
> > > >=20
> > > > I've put the series in a branch "of-pci" of my powerpc.git repo at:
> > > >=20
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git of-p=
ci
> > > >=20
> > > > Please let me know if you're ok (and maybe give me Ack's) and I'll =
ask
> > > > Stephen to add it to next.
> > >=20
> > > Yeah, the generic bits look good to me, you can add my
> > >   Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> >=20
> > Great. Will do. I'll ask Stephen to that that in -next then and will ask
> > Linus to pull directly at the next merge window, separately from
> > powerpc.git (tho I might actually end up pulling that tree into
> > powerpc.git too as I might end up with stuff that depends on it).
>=20
> Allright, Stephen, can you stick this into -next please ?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git of-pci
>=20
> I've added Jesse's acks.

OK, I have added this today.

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

--Signature=_Wed__8_Jun_2011_10_28_14_+1000_FKGpw+nwG4pLPa3J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7sIeAAoJEDMEi1NhKgbsCoUIAIPTLDrmSCXgdGglaPIo7HbJ
HMu114SSZsuG9EP1qaMR71D5HMXS+1gCG58qdv/3+3kXWB70dHfbj/VHcL+cEexv
I3FQpFyvHh6Epqt2ykAbrW92tRclWOiwWU3zaMrnznjqVhqG7fzJv8iuU8KzfUe+
5OczvykNfWIik3zP7T/Mp46xrxxe7qpynNpnxXeOl0kvN11Ss0FBW60Frv24zb3n
s8l3OfRWCt5U72u27gY9DXttPsEwy0FdBLFJ8/Uoj1lHHfEFiWEVVN66NhF681KF
crp+mH/kRL01RcX0iEm9w32stpg5NtjE0RX5HKwlUfmCV7tIgwnbzRmc3HwlugU=
=/6p2
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Jun_2011_10_28_14_+1000_FKGpw+nwG4pLPa3J--
