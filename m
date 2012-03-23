Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab2CWMvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 08:51:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55805 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab2CWMvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 08:51:18 -0400
Date: Fri, 23 Mar 2012 23:50:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Hugh Dickins <hughd@google.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Mel Gorman <mgorman@suse.de>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: linux-next: Tree for Mar 23: doubled patch in vmscan.c
Message-Id: <20120323235045.d1117e2c18c935a31547f305@canb.auug.org.au>
In-Reply-To: <alpine.LSU.2.00.1203230303260.31362@eggly.anvils>
References: <20120323172333.9af9b678fcde0e6e75b5f6dd@canb.auug.org.au>
	<alpine.LSU.2.00.1203230303260.31362@eggly.anvils>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__23_Mar_2012_23_50_45_+1100_=ykdPAx846lyrfAx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Mar_2012_23_50_45_+1100_=ykdPAx846lyrfAx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hugh,

On Fri, 23 Mar 2012 03:29:26 -0700 (PDT) Hugh Dickins <hughd@google.com> wr=
ote:
>
> I'm amused to notice that your merging process is as impatient as akpm,
> and just cannot wait for Mel to remove lumpy reclaim from mm/vmscan.c.

git rebase tried too hard :-(

> It has chosen to do so itself, by duplicating Konstantin's "mm: forbid
> lumpy-reclaim in shrink_active_list()" (we had expected that to be held
> back, but it's gone in anyway, oh well) into shrink_inactive_list(),
> overriding the set_reclaim_mode() a few lines above with a spurious
> reset_reclaim_mode(sc).
>=20
> I expect that will sort itself out automatically once you get an update
> from akpm, but something to beware of meanwhile (probably just a matter
> of deleting Konstantin's patch from your trove now it's in Linus's tree).

Thanks for noticing this.  I will remove that patch from linux-next for
Monday in case Andrew doesn't get around to sending me a new series by
then.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au


--Signature=_Fri__23_Mar_2012_23_50_45_+1100_=ykdPAx846lyrfAx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPbHGlAAoJEECxmPOUX5FEiLUP/jr2AWL+456d4Kw1pAMFjq8y
vJk29LHqP74evRzGLq2zXAzzaa4Kq53bcTykZp9h6yc4YsnlBT1R4nBUP4+3CE/5
ojCKOBG8XUJ/yR9zXmS8PbTzjoAXYLv84S3JUdBl4yDhfVnAfBYp+CY61TxP2+Q8
P3YoZg7Wzy2MLWPFP/gRL/41AZ6Nz/kQv2/1j8v/LygRcZTxa7GfsgNDzKQEBBwY
M17B8sS27SjFw9NWkiwis4CJinlTrC+Enq5DoV6Wi5bSWZ0ggCiJOKioiGS0FO9h
Rr2G6je04yxwf3OrrH6z3zzTBXrDyOQa6RXkUkeJlrty5bOM2EEe4acmEw5nHr8w
OBioqwm3S4dYl7DmOTvexHDDvXkY6gMDZuMA2Thao02TuuIOB7Fzf5xpyFhrx9+5
m2lliYDYHuktSDUu+G59W8/Kxm4tlfkK2Gs44VUaWIwy0AC6aeMX9MLDhH+8K33C
+gkuqXottyVGjS2oFDLuEY0il8+Pv9ZUWYmPUH+Prl3lpW162JqC8XPQH9U/RL67
UZ17/BTL9X8HvKgMG0rO/HfHVPWXlRAaFWTNDkLPjgfctEP2CnQAwpMafpkvXhxu
RIm0TxLK8oyQJfd0Y7LcQkGVqHRU6zUneHTfwovAwxGgLMAqN9vr0tOUNYAn4gBm
VuKklTLE6GaQ1z2Bwz9A
=0ouk
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Mar_2012_23_50_45_+1100_=ykdPAx846lyrfAx--
