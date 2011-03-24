Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515Ab1CXSlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:41:17 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:40965
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933056Ab1CXSlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:41:14 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bh8275dhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LIKRWE-01-1C9-02
X-M-MSG: 
Date: Thu, 24 Mar 2011 19:41:00 +0100
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] oprofile: Allow setting EDGE/INV/CMASK for Intel
 counter events v2
Message-ID: <20110324184100.GP31407@erda.amd.com>
References: <1300304673-4823-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1300304673-4823-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.03.11 15:44:33, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> For some performance events it's useful to set the EDGE and INV
> bits and the CMASK mask in the counter control register. The list
> of predefined events Intel releases for each CPU has some events which
> require these settings to get more "natural" to use higher level events.
> 
> oprofile currently doesn't allow this.
> 
> This patch adds new extra configuration fields for them, so that
> they can be specified in oprofilefs.
> 
> An updated oprofile daemon can then make use of this to set them.
> 
> v2: Write back masked extra value to variable.
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/oprofile/nmi_int.c    |    5 +++++
>  arch/x86/oprofile/op_counter.h |    1 +
>  2 files changed, 6 insertions(+), 0 deletions(-)

Applied to

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Thanks Andi,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

