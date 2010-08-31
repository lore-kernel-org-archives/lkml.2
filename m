Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab0HaJ0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 05:26:30 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:22628 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab0HaJ02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 05:26:28 -0400
X-SpamScore: 9
X-BigFish: VPS9(zzbb2cK1431J98dNzz1202hzzz32i2a8h5bep5bfs43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L80EKT-02-0B3-02
X-M-MSG: 
Date: Tue, 31 Aug 2010 11:05:18 +0200
From: Robert Richter <robert.richter@amd.com>
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] x86: oprofile: fix oprofile_arch_init behaviour on
 failure
Message-ID: <20100831090518.GZ22783@erda.amd.com>
References: <1283107921-21464-1-git-send-email-will.deacon@arm.com>
 <1283107921-21464-2-git-send-email-will.deacon@arm.com>
 <1283107921-21464-3-git-send-email-will.deacon@arm.com>
 <1283107921-21464-4-git-send-email-will.deacon@arm.com>
 <20100830090929.GU22783@erda.amd.com>
 <1283244880.645.17.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1283244880.645.17.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.08.10 04:54:40, Will Deacon wrote:
> Do you think it would be better to rework this patch so that the static
> using_nmi variable is set explicitly by init.c, or shall I just drop
> this patch altogether (and resubmit the first two)?

For x86 wont change the code (actually I found a bug in the init_sysfs
error handler for which I will send a fix). Just wanted to get your
confirmation in case I was missing something that x86 is not affected.
I will apply the first 2 patches, no need to resubmit.

Thanks Will.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

