Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab0LPKhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:37:43 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:2750 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab0LPKhj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:37:39 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Joe Perches" <joe@perches.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 16 Dec 2010 02:33:31 -0800
Subject: RE: [PATCH 0/8] staging: brcm80211: Cleanup
 include/proto/ethernet.h
Thread-Topic: [PATCH 0/8] staging: brcm80211: Cleanup
 include/proto/ethernet.h
Thread-Index: AcubKeDG3JiH42C+QD2f/jBL0emX9gB4s7CF
Message-ID: <400C43189542CE41BC0A5B252FC90136952F0594CF@SJEXCHCCR02.corp.ad.broadcom.com>
References: <cover.1292287720.git.joe@perches.com>
In-Reply-To: <cover.1292287720.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 611733845L83882240-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe

Thanks for digging in. I had same changes and some other in store for the driver, but pending some testing did not post them yet.

Greg,

Could you add my Acked-by to this patch series:
Acked-by: Arend van Spriel <arend@broadcom.com>

Gr. AvS
________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of Joe Perches [joe@perches.com]
Sent: Tuesday, December 14, 2010 1:56 AM
Cc: linux-wireless@vger.kernel.org; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] staging: brcm80211: Cleanup include/proto/ethernet.h

Use the standard kernel mechanisms and remove some entries from this file.

Joe Perches (8):
  staging: brcm80211: Remove unused #defines ETHER_<foo>_LOCALADDR
  staging: brcm80211: Convert ETHER_IS_MULTI to is_multicast_ether_addr
  staging: brcm80211: Remove unused ether_<foo> #defines and struct
  staging: brcm80211: Convert ETHER_IS<FOO> to is_<foo>_ether_addr
  staging: brcm80211: Convert ETHER_ADDR_LEN to ETH_ALEN
  staging: brcm80211: Remove ETHER_HDR_LEN, use ETH_HLEN
  staging: brcm80211: Remove unused ETHER_TYPE_<foo> #defines
  staging: brcm80211: Convert ETHER_TYPE_802_1X to ETH_P_PAE

 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |    8 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   32 +++++-----
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |   38 ++++++------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |    2 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |   63 ++++++++++----------
 drivers/staging/brcm80211/include/proto/ethernet.h |   54 +++--------------
 drivers/staging/brcm80211/sys/wl_mac80211.c        |    2 +-
 drivers/staging/brcm80211/sys/wlc_ampdu.c          |    2 +-
 drivers/staging/brcm80211/sys/wlc_bmac.c           |    9 ++-
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |   40 +++++++------
 drivers/staging/brcm80211/util/bcmsrom.c           |   15 +++--
 12 files changed, 118 insertions(+), 149 deletions(-)

--
1.7.3.3.398.g0b0cd.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


