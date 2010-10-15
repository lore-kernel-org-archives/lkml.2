Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab0JONz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:55:29 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:21166
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756097Ab0JONz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:55:27 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0LAC404-01-3TS-02
X-M-MSG: 
Date: Fri, 15 Oct 2010 15:55:17 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 0/7] oprofile, x86: updates for AMD family 12h and 14h
 systems
Message-ID: <20101015135517.GG5969@erda.amd.com>
References: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1286546192-18593-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.10.10 15:56:25, Robert Richter wrote:
> This patch set adds support for AMD family 12h and 14h systems. Main
> part here is the support of new IBS features (branch target address
> reporting and periodic op counter extension).
> 
> Please review. If the patches are fine I will apply them to the
> oprofile git repostitory on kernel.org. They depend on the APIC
> patches I send out earlier.
> 
> Suravee will send updates to the oprofile userland soon.

I applied the patches to the oprofile/x86 branch.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

