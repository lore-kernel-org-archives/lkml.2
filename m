Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab2KEVyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:54:09 -0500
Received: from mailserver6.natinst.com ([130.164.80.6]:39969 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab2KEVyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:54:07 -0500
Date: Mon, 5 Nov 2012 15:54:10 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v3] ARM: zynq: Allow UART1 to be used as DEBUG_LL console.
Message-ID: <20121105215410.GC1254@beefymiracle.amer.corp.natinst.com>
References: <1352151949-18319-1-git-send-email-nbowler@elliptictech.com>
MIME-Version: 1.0
In-Reply-To: <1352151949-18319-1-git-send-email-nbowler@elliptictech.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/05/2012 03:54:01 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/05/2012 03:54:01 PM,
	Serialize complete at 11/05/2012 03:54:01 PM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-11-05_03:2012-11-05,2012-11-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 05, 2012 at 04:45:49PM -0500, Nick Bowler wrote:
> The main UART on the Xilinx ZC702 board is UART1, located at address
> e0001000.  Add a Kconfig option to select this device as the low-level
> debugging port.  This allows the really early boot printouts to reach
> the USB serial adaptor on this board.
>
> For consistency's sake, add a choice entry for UART0 even though it is
> the the default if UART1 is not selected.
>
> Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
> Tested-by: Josh Cartwright <josh.cartwright@ni.com>
> ---
> Sorry all for the phenominal delay in sending this out.  Josh, I kept
> your Tested-By since this version is Obviously Equivalent??? to v2...

I re-tested again just in case and everything is good.

Thanks,
  Josh

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQmDWCAAoJEEef0niEbw+lEsAP/0tY6P3M9g0W3QlMid9XcTAL
bYl39DBKkxiHb+6Hp5lfX0I8Ojb97aE47uVMqLqI1Rxdqos9gT1lGCYqERwp5R1d
fwRdgpP9ZID0cOTLh7pWHGiHG2C3VLRgsP/i/uhhzsoc/11V6v23ViKgEkfsd2vB
px6cc0QfZReiUTx9fIhq9HkwYrYbk444YkJLeqjWpLEp7rNRmT6Nuy7vwRT7XkSG
/0NnpDGtK9fK/QYNbBeb5S6SNRwuxz6nyQDRJVkoqcej8pzM3KF8IpWakef12yd5
naUC3bTnYI3iTUURExhz9Fe8fPZNP/OntklnQc5KSJCVHBFVHMOCMJ5fSN1DxxN/
2OMWtB3Y7LmUCD4F4YxIwJVSwskLfTZ7ueHuEwFlr1YTbeu713IdNN4L7yCI4YSp
ugpfgjtrJO5vSncuWt8fvnO6Ipps3789hZmFU7pnH5lyh1bXQEfZh6UKl9SfBTMO
uiGdjr+NmAEryZBDjgcxQpG0fdC3k0bqRlFBqJo2fRUaeDoFjVtBsjYzzrxAx2Z2
FpHN1BY9E4Fa8/3dI+A5ljx4YhV6/Zs2z6LkpGF/4vSF5gudHFlEVBIONFQJTkly
t5QJ2oYEz0wa/sfcWid1JkHo6CeHojeYQxjRaKi6K5O9631cZ5ka5NXGhYjixEvF
LOUOi82E8FtZavdVkZrV
=YlRL
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
