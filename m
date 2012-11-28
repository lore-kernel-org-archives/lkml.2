Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2K1ABi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 19:01:38 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45684 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2K1ABg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 19:01:36 -0500
Date: Wed, 28 Nov 2012 11:01:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: unusual update of the security tree
Message-Id: <20121128110132.0082c87680b9b714b8c0689c@canb.auug.org.au>
In-Reply-To: <50B5508D.7050409@schaufler-ca.com>
References: <20121128101635.d5e864dffc4252ef9d5e1664@canb.auug.org.au>
	<50B5508D.7050409@schaufler-ca.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Nov_2012_11_01_32_+1100_3gUB+hYUPNg7oVEZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Nov_2012_11_01_32_+1100_3gUB+hYUPNg7oVEZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Casey,

On Tue, 27 Nov 2012 15:45:17 -0800 Casey Schaufler <casey@schaufler-ca.com>=
 wrote:
>
> On 11/27/2012 3:16 PM, Stephen Rothwell wrote:
>=20
> > The security tree
> > (git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.g=
it#next)
> > looks a bit strange today ... It appears to have been created by Casey
> > Schaufler (cc'd) and contains some quite old commits and back merges of
> > your tree.  I *guess* you have merged in Casey's tree after he merged in
> > your tree from yesterday.
>=20
> I *thought* that I had used the same procedures that worked before.
> In fact, I still do think that, but if it's a problem I can purge my
> smack-next tree and start over.
>=20
> James, the two changes that came from smack-next are pretty minor. I
> don't think you should hesitate to back them out if that helps.

This is the shortlog for the changes in the security tree between
yesterday and today;

Casey Schaufler (32):
      Commit 272cd7a8c67dd40a31ecff76a503bbb84707f757 introduced     a chan=
ge to the way rule lists are handled and reported in     the smackfs filesy=
stem. One of the issues addressed had to     do with the termination of rea=
d requests on /smack/load.     This change introduced a error in /smack/cip=
so, which shares     some of the same list processing code.
      Revert "Commit 272cd7a8c67dd40a31ecff76a503bbb84707f757 introduced"
      Smack: smackfs cipso seq read repair
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Smack: recursive tramsmute
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Smack: allow for significantly longer Smack labels v4
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Smack: fix smack_new_inode bogosities
      Smack: Maintainer Record
      Smack: onlycap limits on CAP_MAC_ADMIN
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Smack: user access check bounds
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Smack: remove task_wait() hook.
      Smack: setprocattr memory leak fix
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Merge branch 'for-1209'
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-security
      Merge branch 'next' of git://git.kernel.org/.../jmorris/linux-securit=
y into for-1211
      Smack: use select not depends in Kconfig
      Smack: create a sysfs mount point for smackfs

Rafal Krypa (2):
      Smack: don't show empty rules when /smack/load or /smack/load2 is read
      Smack: implement revoking all rules for a subject label

Tetsuo Handa (1):
      gfp flags for security_inode_alloc()?

It's a bit of a mess :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Nov_2012_11_01_32_+1100_3gUB+hYUPNg7oVEZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtVRcAAoJEECxmPOUX5FEPe8P/00LXOEL3+/c31GjrlZhLJPE
aD1FNROONnp+K0h0WWiD4yXSGTSIU7TuP4Ik9Grg+zNiWpH9Ur3JvCFP7lHWhsb8
6ktJnQFfAR+Jm4F4c/UXiRZL6sOoIpSY0j3nWrA74Yw3wnIbTC+RD8tbgHKAGiiW
4l3ynH7yhCg2Le9xn2jyTX8c6D1dL6nKWJVUJtr/4aNJ4BTekVvRGKZye3eQK1Ft
sDHe0qnM6zBCIIMiShEEumoHwpgFtSCfQaoKIUbihaFCxU9Nauu6XeJiPaXwg9nv
zReUwDX9LxFA6K7HtqYAnHoRNDNxlHpRtwSvllr18BaOlQxN99Qqf9C/HeZePdtL
mSqTYQswPYgJGGoSUE4D8sRHrfJUvb9up3ddGwKm4c/S/uUWXekG4GG1GVm0o/a4
x7/lDrgaAAbaTTsS0kDBnZq35GRCCxmglTPkCW3gUW6oW2T/JQksOQe1dNHPdqyZ
pz7pVaIi6yQMGUfADDXgBZd3BAI4s6I0W0nGRimi1ywd7IZ5dK3/nJZg8KdADSu7
o9PPrg1LxKvZBzyj43IHoC4q9MSbd3rI/TYSDU/IP2QjbUBqvIxpu94qZOnUjc+9
OVvGOO2x60PdNaFQ8b6MZ+WIN7iqk5ZERB48jcM8kZe8r7s/zvc1gUeJZAPrTXIb
6f0tBgMgoTHGh1iBch1i
=FmO/
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Nov_2012_11_01_32_+1100_3gUB+hYUPNg7oVEZ--
