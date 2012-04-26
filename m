Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab2DZNMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 09:12:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49362 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab2DZNMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 09:12:16 -0400
Date: Thu, 26 Apr 2012 23:12:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Tags for successful compilations of linux-next
Message-Id: <20120426231203.b1fbc86e26b2c9b426b81a64@canb.auug.org.au>
In-Reply-To: <CAB=NE6W85xRWajvuMm3MnAXebwU-+=6H+Za+W6F-fiVTH_VpXQ@mail.gmail.com>
References: <CAB=NE6W85xRWajvuMm3MnAXebwU-+=6H+Za+W6F-fiVTH_VpXQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__26_Apr_2012_23_12_03_+1000_Q9EG62y7h8OrNhEC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__26_Apr_2012_23_12_03_+1000_Q9EG62y7h8OrNhEC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Luis,

On Thu, 26 Apr 2012 05:32:13 -0700 "Luis R. Rodriguez" <mcgrof@frijolero.or=
g> wrote:
>
> As a daily consumer of linux-next I'm wondering if there are tags that
> perhaps could be introduced to annotate when a linux-next tag itself
> did successfully compile across all the tests you have for linux-next
> each day. As a consumer of linux-next, for example, I could just take
> those tags to ensure my own snapshots do compile as well. Checking
> with you to see if this is worth it for an extra tag to annotate these
> somehow.

Linux-next has never built for all the test builds we do :-(  However,
(almost) every linux-next release does build for the following:

PowerPC: ppc64_defconfig, allnoconfig, (64bit) allnoconfig, ppc44x_defconfi=
g,
         allyesconfig (fails in the final link)
X86_64: allmodconfig
i386: defconfig
sparc: 32 and 64 bit defconfig

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__26_Apr_2012_23_12_03_+1000_Q9EG62y7h8OrNhEC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPmUmjAAoJEECxmPOUX5FEPaMP/j4FURTQTW+f26aJ+geZlmOf
zg+WHEN3DfcjwzURhXPU939Oc6Vt1iOU2FTFv3WAx6t/hP+RqwEz6kEEV2+yAxA7
fjWELgRnh2dr1NraxHXE9m+EKpnwddRIPrNuj6GYsBgTthaQgh8dBpG8ynG1gPbl
EDxX7+QiR3lB5RsO6DPZdYXdR1quMEQN/S3ae1v31U5lH1jOQkQ3iVcqRtwHu5FY
roWnudKnX/+fa5xv90UoBxW/HVjcigJSX4rBWdh+ql4iqoDCs9c3iWWL2rEcnfR6
GLwEMyGPXH6ZXbdOA+WrOtfcAFlLDKtJREu1eYNmpZMCANedwmYQ4zZcbkCrozFN
qD7+Kz87Bhi9PyeX+JIodTaU2yEhntNlWoYDEvvolIlQqhNFg1C02xhuLFo4/HN9
G8zFEE670/Qcn1YbDUxcdsm+wmVFddcaDCT48AlwJXqr7WWpnXeujAP9wWr6Yvfc
6Fy07bfDpkEoaywPf6PFf8+aIokrBdBLNnlza0vJRJZkWzdgZovVppFSE5txEXNs
S6NHSiSTZNrADHZ52Yb/kPo/NXFs2CdGHAOSSPKpRbrMVxkMMwbeH4gY6YVy4C0J
qZTn2kuO1zlAgpK5rNnoG7qjiRd0k1IFHOY6Q72iq+yqskmHK90QPXkyLp4TTs4V
OBFF6p+rI+gSGJWZp8wJ
=qqHV
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Apr_2012_23_12_03_+1000_Q9EG62y7h8OrNhEC--
