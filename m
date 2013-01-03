Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3ACTlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 14:41:06 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:53053 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753636Ab3ACTlE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 14:41:04 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Akinobu Mita <akinobu.mita@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "David S. Miller" <davem@davemloft.net>, Michael Chan <mchan@broadcom.com>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        Jean-Paul Roubelat <jpr@f6fbb.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 3 Jan 2013 11:36:54 -0800
Subject: RE: [PATCH -v2 18/26] drivers/net: rename random32() to
 prandom_u32()
Thread-Topic: [PATCH -v2 18/26] drivers/net: rename random32() to
 prandom_u32()
Thread-Index: Ac3prLATjugW98T+Tx+4MRca0Cvl0AAPK9XA
Message-ID: <477F20668A386D41ADCC57781B1F70430D13EA8B31@SC-VEXCH1.marvell.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
 <1357215562-6288-19-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1357215562-6288-19-git-send-email-akinobu.mita@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akinobu,

> Use more preferable function name which implies using a pseudo-random
> number generator.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Acked-by: Thomas Sailer <t.sailer@alumni.ethz.ch>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Michael Chan <mchan@broadcom.com>
> Cc: Thomas Sailer <t.sailer@alumni.ethz.ch>
> Cc: Jean-Paul Roubelat <jpr@f6fbb.org>
> Cc: Bing Zhao <bzhao@marvell.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-hams@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org

Acked-by: Bing Zhao <bzhao@marvell.com> [mwifiex]

Thanks,
Bing

> ---
> 
> No change from v1
> 
>  drivers/net/ethernet/broadcom/cnic.c    | 4 ++--
>  drivers/net/hamradio/baycom_epp.c       | 2 +-
>  drivers/net/hamradio/hdlcdrv.c          | 2 +-
>  drivers/net/hamradio/yam.c              | 2 +-
>  drivers/net/wireless/mwifiex/cfg80211.c | 4 ++--
>  5 files changed, 7 insertions(+), 7 deletions(-)

