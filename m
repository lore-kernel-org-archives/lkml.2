Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab0I1PQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:16:29 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:45041
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755031Ab0I1PQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:16:28 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1432N98dN4015Lzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9GQF4-01-2WQ-02
X-M-MSG: 
Date: Tue, 28 Sep 2010 17:16:18 +0200
From: Robert Richter <robert.richter@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: Don Zickus <dzickus@redhat.com>, huang ying <huang.ying.caritas@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 7/7] x86, NMI, Remove do_nmi_callback logic
Message-ID: <20100928151618.GD13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-7-git-send-email-ying.huang@intel.com>
 <20100927104426.GD32222@erda.amd.com>
 <AANLkTinA2HK57w5wqCtq319WNy-PLtWaGBe-v+uoFB=Y@mail.gmail.com>
 <20100927134341.GQ13563@erda.amd.com>
 <20100927151607.GX26290@redhat.com>
 <20100927165831.GT13563@erda.amd.com>
 <1285638103.20791.152.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285638103.20791.152.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.09.10 21:41:43, Huang Ying wrote:
> unknown_nmi_panic will cause panic for unknown NMI (can not identify the
> NMI sources).
> 
> panic_on_unrecovered_nmi should panic for unrecovered hardware errors,
> for known and unknown NMI. For example, panic_on_unrecovered_nmi will
> cause panic in mem_parity_error too, which can be considered known NMI.
> 
> Is it reasonable?

Yes, this makes it clear. Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

