Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab0CaRzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 13:55:32 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:45959 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab0CaRza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 13:55:30 -0400
X-SpamScore: -29
X-BigFish: VPS-29(zz1432R98dN936eM9371Pzz1202hzzz2fh2a8h6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4BB38C83.9090808@am.sony.com>
Date: Wed, 31 Mar 2010 10:55:15 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>, Zhu Yi <yi.zhu@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       "cbe-oss-dev@ozlabs.org" <cbe-oss-dev@ozlabs.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 5/7] drivers/net: Remove local #define IW_IOCTL, use
 STD_IW_HANDLER
References: <cover.1268892663.git.joe@perches.com> <696c60e097ff35aeb2d746d1a0edf167514f2b61.1268892664.git.joe@perches.com>
In-Reply-To: <696c60e097ff35aeb2d746d1a0edf167514f2b61.1268892664.git.joe@perches.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2010 17:55:22.0268 (UTC) FILETIME=[557685C0:01CAD0FB]
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/17/2010 11:21 PM, Joe Perches wrote:
> Use #define STD_IW_HANDLER from wireless.h instead
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ps3_gelic_wireless.c       |   35 +++++++-------
>  drivers/net/wireless/ipw2x00/ipw2200.c |   83 ++++++++++++++++----------------
>  2 files changed, 58 insertions(+), 60 deletions(-)

Sorry for the delay.  This looks fine for the PS3.

Acked-by: Geoff Levand <geoff@infradead.org>

