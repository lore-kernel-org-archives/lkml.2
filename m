Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab0I3IXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 04:23:46 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:35085
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147Ab0I3IXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 04:23:44 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zzbb2cK98dNzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L9JWN7-02-4PQ-02
X-M-MSG: 
Date: Thu, 30 Sep 2010 10:23:33 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: huang ying <huang.ying.caritas@gmail.com>,
        Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 7/7] x86, NMI, Remove do_nmi_callback logic
Message-ID: <20100930082333.GT13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-7-git-send-email-ying.huang@intel.com>
 <20100927104426.GD32222@erda.amd.com>
 <AANLkTinA2HK57w5wqCtq319WNy-PLtWaGBe-v+uoFB=Y@mail.gmail.com>
 <20100927134341.GQ13563@erda.amd.com>
 <20100927151607.GX26290@redhat.com>
 <1285633705.20791.84.camel@yhuang-dev>
 <20100928151924.GJ26290@redhat.com>
 <AANLkTinuNKfTBYTK1+Ks-QSPbQ3qz5cCZC6vUwUZ+zCh@mail.gmail.com>
 <20100930040432.GD26290@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100930040432.GD26290@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.09.10 00:04:32, Don Zickus wrote:
> I guess I still prefer to take your patch set with its change and then
> layer any new ideas on top.  I have a feeling this discussion could go on
> forever regarding how die_chains can work.

I agree here, the patches are the beginning to cleanup the code. But
we should avoid fundamental functional changes which could lead to
unexpected new behavior, esp. we should keep kernel interfaces like
parameters and printouts.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

