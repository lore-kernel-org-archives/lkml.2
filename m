Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037Ab0HJEYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 00:24:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56049 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab0HJEYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 00:24:41 -0400
Date: Tue, 10 Aug 2010 14:24:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs series, part 1
Message-Id: <20100810142434.8ae6912a.sfr@canb.auug.org.au>
In-Reply-To: <20100810033536.GA31363@ZenIV.linux.org.uk>
References: <20100810033536.GA31363@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__10_Aug_2010_14_24_34_+1000_ikV/JxhojIezyAYV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Aug_2010_14_24_34_+1000_ikV/JxhojIezyAYV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Tue, 10 Aug 2010 04:35:36 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> 	Assorted work from the last cycle; among other things, there's
> a filesystem API change (->evict_inode() series), a lot of truncate
> rework stuff (mostly by Chris) and a bunch of fixes.

Did you remember to apply the three fix patches I sent you?  Two were for
evict_inode fixups (cifs and xfs) and one was inode_setattr removal fixup
(for v9fs).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__10_Aug_2010_14_24_34_+1000_ikV/JxhojIezyAYV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMYNSCAAoJEDMEi1NhKgbsadYH/RhI4wvK8zlgFet5xbSs+/y4
Jq5Js7BIGeXjnnF2Vyiar0zyG89y7kfOXlKBa0rGXUxwFyyyccyYaGXoOnbdcGBg
zVywfNeznDJdmvljAGwzYZfvPBpeikP9BVRIFjLy1hI7ovS6UspH+R6pzAyca2DM
YGsiYYTQbtpzkJBzxTJWwoxSrLB+kXbwDTErRVqUtCscHdORf2K1wAlfRDHDqw1R
XhlfAzm8/FSo38reF8xZfsxIZ/PZkDgBJUsyLtfnhVAN0/czCP0bkl8PzNBDgAFs
TIIWCagklevygUPjwU3PYcD8YEx48Q0cKgmtmMGJzFDzfY0tvA072U5MtOw9BMc=
=NmIC
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Aug_2010_14_24_34_+1000_ikV/JxhojIezyAYV--
