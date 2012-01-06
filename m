Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab2AFXzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:55:39 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54143 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758674Ab2AFXyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:54:38 -0500
X-Sasl-enc: d/R5xJUdcxa3kdJG/v4ghxNbvj0MOeEqPKje/3QQxKa3 1325894074
Date: Fri, 6 Jan 2012 15:53:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.53
Message-ID: <20120106235343.GA15142@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 2.6.32.53 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at (NOTE THE ADDRESS CHANGE):
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-2.6.32.y

thanks,

greg k-h

------------

 Makefile                              |    2 +-
 arch/arm/plat-mxc/pwm.c               |   16 +++++++++++++++-
 block/cfq-iosched.c                   |   11 +++++++++--
 drivers/mmc/host/mmci.c               |    6 +++++-
 drivers/net/wireless/ath/ath9k/main.c |    3 +++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c  |    2 +-
 drivers/watchdog/hpwdt.c              |    5 ++++-
 kernel/hung_task.c                    |   14 ++++++++++----
 mm/filemap.c                          |    7 ++-----
 9 files changed, 50 insertions(+), 16 deletions(-)

Anton Blanchard (1):
      SCSI: mpt2sas: _scsih_smart_predicted_fault uses GFP_KERNEL in interrupt context

Dave Kleikamp (1):
      vfs: __read_cache_page should use gfp argument rather than GFP_KERNEL

Greg Kroah-Hartman (1):
      Linux 2.6.32.53

Jason Chen (2):
      MXC PWM: should active during DOZE/WAIT/DBG mode
      ARM:imx:fix pwm period value

Mandeep Singh Baines (1):
      hung_task: fix false positive during vfork

Mingarelli, Thomas (1):
      watchdog: hpwdt: Changes to handle NX secure bit in 32bit path

Mohammed Shafi Shajakhan (1):
      ath9k: Fix kernel panic in AR2427 in AP mode

Ulf Hansson (1):
      ARM: 7220/1: mmc: mmci: Fixup error handling for dma

Yasuaki Ishimatsu (1):
      cfq-iosched: fix cfq_cic_link() race confition


--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPB4mHAAoJEDjbvchgkmk+wCgQAIjb7FszVcAZ0jGeZUZMpj4Z
ceKubXLhXXwEh9R6fpCucoKyfNqxi5sOd5+BbLhROsP6wV9GAMaPWJyyZJIDpx62
1sNdLXXPwmv64q8W5kqdrxn1kO5japlCrvlWeMShnSb7xZjI55zauRf8pwRXfGO4
1D+cPjs0KcmGCOkp+wvcJ+Yxh66SnAo7rhfccpQHy4mvw7imbfSYlaI4MpEq/8nl
iw+F+k0wc5LEeXlqNUe4vsFINzrxG7Akh86cnH4KI6FVP2Yea09snlJD137cQ1Ko
HvsT+8mXWB2apPXDsBVhwJCqd8/UJr9qrowWzERvuKsR+TLOpscpdzrB/k+vmyec
TcUuFbfhtLFAAn3ils+41Mw4qG+a8QNk2r1nDPfdy4u3uA7ShMseLXB9u7XMxdDW
dHl2a84bSkvpVI1iDKumq1auOMNG7Xc5ImuUtrUPIqqhdSIhTvPO7hnSdpR4gDfp
U1rwn7s8Ao6Azlczw4Wc/nUwGXNfFkRVNsvL63p9mgNH8X56nQ5ZrbJqSU+0PKYZ
BQvYgiWBMGM3HGQOmbJK9bs+DVxlpze/2CKx6tc4GFaC3RIM6x4vpfK73voOmt9h
2d9dGSMnKRbaxzqOrOuMX/2EXcghmeuy/2wC6KOTNMkwIdU66dbHpJD2bI3xs5fe
DvdxKdmHNqD1kevDFOo6
=gqvx
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
