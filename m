Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2APLdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 06:33:53 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39551 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab2APLdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 06:33:51 -0500
Date: Mon, 16 Jan 2012 14:37:59 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
        Tony Luck <tony.luck@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com
Subject: Re: 3.2.0-07927-gc49c41a: s2ram: Device 'machinecheck1' does not
 have a release() function, it is broken and must be fixed
Message-ID: <20120116143759.4c498831@sf.home>
In-Reply-To: <4F140872.3090409@linux.vnet.ibm.com>
References: <20120116131842.53f7ccc8@sf.home>
	<4F140872.3090409@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pR3DlTCHhh76DsVy/XmpZRw"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/pR3DlTCHhh76DsVy/XmpZRw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> But the only reason I haven't really jumped into writing such a patch
> is that I would prefer to get the semantics right - adding a dummy
> function is IMO something like working around the rules of the driver-core
> framework just to silence the warning. Hence I feel we should resort
> to it _only_ if there is nothing better we can do about this.

Ah, I see. Will ignore the warning.
Thanks for the detailed explanation!

Sorry for the noise.

--=20

  Sergei

--Sig_/pR3DlTCHhh76DsVy/XmpZRw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk8UDBcACgkQcaHudmEf86qBJwCfasyPESHoIdQsVjjpkOZYI9tL
tkoAn12mOvf/3gSdlHZU/bScDmqvtM1h
=cWCP
-----END PGP SIGNATURE-----

--Sig_/pR3DlTCHhh76DsVy/XmpZRw--
