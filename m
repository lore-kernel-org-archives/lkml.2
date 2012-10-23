Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165Ab2JWXmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:42:31 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:51954 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab2JWXm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:42:29 -0400
Date: Tue, 23 Oct 2012 18:42:19 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH v2 2/4] zynq: move static peripheral mappings
Message-ID: <20121023234219.GM20593@beefymiracle.amer.corp.natinst.com>
References: <20121022211219.GC31538@beefymiracle.amer.corp.natinst.com>
 <201210231450.11540.arnd@arndb.de>
 <20121023162641.GG20593@beefymiracle.amer.corp.natinst.com>
 <20121023202703.GA16912@elliptictech.com>
MIME-Version: 1.0
In-Reply-To: <20121023202703.GA16912@elliptictech.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/23/2012 06:42:14 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/23/2012 06:42:14 PM,
	Serialize complete at 10/23/2012 06:42:14 PM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iRjOs3ViPWHdlw/I"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-23_09:2012-10-23,2012-10-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iRjOs3ViPWHdlw/I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 23, 2012 at 04:27:03PM -0400, Nick Bowler wrote:
>
> Just FYI, I sent a patch to fix the same bug a while back
>
>   https://patchwork.kernel.org/patch/1156361/
>
> together with other patches to fix early printk on the ZC702 serial
> console.  Admittedly, I dropped the ball on these as other issues
> came up so I was away from the Zynq for a while.
>
> However, I'm now getting back on the Zynq and have a bunch of patches to
> make it all work on the ZC702 board.  I've respun the ZC702 early boot
> fixes against newer git but they're obviously going to conflict with
> this series.  Should I resend them anyway?

If you have other fixes for the zc702, that'd be great.  Most of my
testing has been in a qemu model; I haven't had a chance to try getting
the zc702 booting yet.

The first stumbling block is that it looks like the secondary uart is
the primary uart on the zc702.

> I also have a DT binding for the TTC driver, I can send that.

That'd be great!

Thanks,

  Josh

--iRjOs3ViPWHdlw/I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhytbAAoJEEef0niEbw+lINUP/AhwceKvuYTD+LlGq4Dk8D5m
lhnmtkIBW1U1KBPLyiKE0DcayLlGgIlSKU/rRYdUAzvzE2x11ztne6AF3qWG2jMq
5vy0rn14utgHrVFrT4/nrsz5oQzUyzmos7qlbotL+YQmxDGzl3Zmc4qSbe9SxoTF
Goy79yXLFs9CJ5sI6HlSk7coA5rJ5xvplgaw75b/1Gsc7ut4tLUwFZx8+etOl9hB
EmnBHbWFUvQAwDNWmOLKJuS2lDnaloqX699Q7bpEvKAZMtSl10POdg5z+ZgBSW4W
DEj181GGawRuzVRjHx37UQ5fwCTcnszv/EriL4+MYBs2YLkubZemA2o8fX3Wd5gk
jPIxgR8Hnny/l+I5+jbXBEND7kcrAEbOy3jmbItB4ih4v53XM0F7+pd4D4+1jjmm
9uS7f/hT8gdBLKuIU5B4D3ZCBLcUBOum2Pt03IqDJDiIJEu8ysDDKrysSFJvgXUe
p9jnVGDAHsAMkKRToOoTGmFUM4bZWmkxwruu/6UsTDrpPEKK4+DKaG8axoWKydjh
10VrqCGT3GWBz/S407z2RdIkLiYKZh/mpjAUKB8QyV943IRdJhVr3hkI28uj/mrX
nvz2z8++sJi8NKA1NJZKSfmCv+wfUufPQNXVEsKp5ed9TPwq4wFfS6FS/VUbQ/0j
PNI4lv/imiU0cBG6ZbHR
=cBnv
-----END PGP SIGNATURE-----

--iRjOs3ViPWHdlw/I--
