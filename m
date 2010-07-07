Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab0GGWjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 18:39:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61288 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab0GGWjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 18:39:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:x-operating-system:user-agent;
        b=mbjfH4UZ+o6/ZFQzkUckpCgOvO9zTOM/eDKW1iBYXsgxeiUwfc1hxvnESncezWUYkX
         e74rPvIUNGRru6pzYyGSld566CqFn2X8iv49tj/Ep3bZdU7DYvgt0fyALpn3tRKbs6Ap
         gLpmwfCDICah0H7yAdl4CK9H47vtq1WyXSH/Y=
Date: Wed, 7 Jul 2010 17:39:37 -0500
From: Brian Kroth <bpkroth@gmail.com>
To: Michael Di Domenico <mdidomenico4@gmail.com>
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: nic enumeration
Message-ID: <20100707223935.GD23117@gmail.com>
Reply-To: Brian Kroth <bpkroth@gmail.com>
Mail-Followup-To: Michael Di Domenico <mdidomenico4@gmail.com>,
	linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
In-Reply-To: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com>
X-Operating-System: Linux 2.6.32-bpo.3-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Michael Di Domenico <mdidomenico4@gmail.com> 2010-07-07 18:25:
> I have an issue where I have an onboard NIC with effectively three
> ports, no other NIC ports/chips are in the system
>=20
> Nic0: xx:xx:xx:00:00:02
> Nic1: xx:xx:xx:00:00:01
> IPMI: xx:xx:xx:00:00:03
>=20
> When I boot RedHat Linux, Nic1 becomes Eth0 and Nic0 becomes Eth1.
>=20
> I understand there is a disconnect between BIOS and linux on which
> device should get which Eth, as well as, what ensues when you have PCI
> cards along side onboard ports.
>=20
> What I'm curious about is how/why Linux actually decides Nic1 should be E=
th0?
>=20
> My theory is it starts on the lowest MAC address and works up,
> depending partly on driver load order.
>=20
> Given the above scenario, swapping the MAC addresses between Nic1 and
> Nic0 would clear this issue.
>=20
> Can anyone confirm or deny this?  Or explain/point me to, how it actually=
 works.

Look into udev.  It should maintain some rules that dictate that
mapping.  If not you can potentially write/alter some to make it do what
you want/expect.

On my systems the place to look is generally here:
/etc/udev/rules.d (user rules)
/lib/udev/rules.d (system rules)

There may be others.

Cheers,
Brian

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkw1AicACgkQdtkBin+QuSAU4wCfd8eNdF3co9PB0BW16prkZytG
NOEAniB5lm/tKzi3CmjuBq2pufkqVRgz
=mhu9
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--
