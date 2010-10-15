Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab0JOMoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:44:18 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:26880
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754210Ab0JOMoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:44:15 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2cK1432N98dN4015L2f55kzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0LAC0P7-02-DBR-02
X-M-MSG: 
Date: Fri, 15 Oct 2010 14:43:57 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: linux-next: manual merge of the oprofile tree with the tip tree
Message-ID: <20101015124357.GC5969@erda.amd.com>
References: <20101012131828.5fedf1bf.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101012131828.5fedf1bf.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.10.10 22:18:28, Stephen Rothwell wrote:

> Today's linux-next merge of the oprofile tree got a conflict in
> arch/arm/oprofile/common.c between commit
> 38a81da2205f94e8a2a834b51a6b99c91fc7c2e8 ("perf events: Clean up pid
> passing") from the tip tree and commit
> 3d90a00763b51e1db344a7430c966be723b67a29 ("oprofile: Abstract the
> perf-events backend") from the oprofile tree.
> 
> The latter moved the code modified by the former, so I used the version
> of this file from the oprofile tree.  I also applied the effect of the
> tip tree patch to the new file drivers/oprofile/oprofile_perf.c:

Stephen,

I merged both trees and updated my oprofile for-next branch. They
should merge now without conflicts.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

