Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973Ab0I0Ku0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:50:26 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:45190 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab0I0KuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:50:24 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L9EJFQ-01-2K7-02
X-M-MSG: 
Date: Mon, 27 Sep 2010 12:50:15 +0200
From: Robert Richter <robert.richter@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 1/7] x86, NMI, Add symbol definition for NMI magic
 constants
Message-ID: <20100927105015.GL13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.09.10 20:57:00, Huang Ying wrote:
> Replace the NMI related magic numbers with symbol constants.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Reviewed-by: Robert Richter <robert.richter@amd.com>

See my comments to patches 3, 4, 6, 7.

-Robert 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

