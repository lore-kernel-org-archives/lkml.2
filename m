Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab2LSTEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 14:04:35 -0500
Received: from mailserver5.natinst.com ([130.164.80.5]:46294 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2LSTE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 14:04:27 -0500
Date: Wed, 19 Dec 2012 13:04:12 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>, monstr@monstr.eu,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>, Arnd Bergmann <arnd@arndb.de>,
        git@xilinx.com, nbowler@elliptictech.com
Subject: Re: [PATCH v2 0/7] Updates for Zynq's timer driver
Message-ID: <20121219190412.GD1005@beefymiracle.amer.corp.natinst.com>
References: <ab760e55-61c2-46b0-b899-1935c213536e@CO1EHSMHS026.ehs.local>
MIME-Version: 1.0
In-Reply-To: <ab760e55-61c2-46b0-b899-1935c213536e@CO1EHSMHS026.ehs.local>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/19/2012 01:03:50 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/19/2012 01:03:50 PM,
	Serialize complete at 12/19/2012 01:03:50 PM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-19_08:2012-12-19,2012-12-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 19, 2012 at 10:16:25AM -0800, Soren Brinkmann wrote:
> I started to put some effort on syncing the Xilinx Linux tree with mainli=
ne and
> the timer driver is my first victim.
> Most commits are fixing style issues or clean up. Functionality is touche=
d only
> in patches #2 and #7.
>=20
> Some patches are present in almost identically in the Xilinx Linux tree a=
nd I
> took over 'Acked-by' lines from those commits.
>=20
> To repost the patch with the arm-kernel list included I made this a v2 to=
 avoid
> confusion about which series is the current one, though the patches are t=
he same
> as the ones posted before on lkml only.
> I added Josh's 'Reviewed-by' line though.

I had a chance this morning to get this set up and running on one of our
Zynq boards this morning in between testing Stephen's clk-zynq changes.
Looks good.

Whoever is going to pick this up (probably Michal), feel free to add my:

Tested-by: Josh Cartwright <josh.cartwright@ni.com>

Thanks,

  Josh

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ0g+sAAoJEEef0niEbw+lIdcQAKntNCA1FmOyegd4O5zSyr47
uEmowgr3Ugm6nP/AukZzxpsOgbqCnt1rHl3FYIUBE5TkTUiFjIi01Esuiv+Q249y
8jZ/ihgl+4rINw/40w4g67TiCiqXKQVAXhMRvmUv7gvBd/hfCxh0/cRn6mf/jox8
38gMpVOtmppxb1x9ovvE7FBPNmjhi5cZTSsypnhRM5Yz/j5ekhXKMxdvEb4kT/bJ
NwnAaNT/Hd61q5oFb2ZJgIKXvZptSI3SDor+DNHdzLmfG1fbaXa75C1O0XMUUSbr
mTIV2fp0mmTX1scF+TZvmcoFS7cqkEqXNcQxt2o1G3NfeM9HA9tHCnIPzCtpi5ne
6UgHLzB0w087mypZJTRmvBKlemD1ljNX8WIYMwkf0lBSgPuyQJ166UYiBP+ytCW5
DJPYCSc4bweDN6nWhuDzu3+gQ9amprfLZcCyuteZpQBZTvMvqWzdUL+UtOUtPUxw
zZHabNNKOmTnNNoIXC55WOLvfAfXwb/FlCS2NxYetsi27LWzZd+FUkBr0OxPK+ff
1o3UymPL8TDM7Aao4lZNn6VewzGj6/JjvJIXWBxmE+gLwzKCgZ3pEDpdJZByFgOG
9zUQz/fhvh415t28q1/hszgufcTphH1VnvOAT9PFGqm5DvTap1IOY/3xIVrZZbDi
LTqzJbkueJML0+t2dSlq
=QMnx
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
