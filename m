Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab0HaJws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 05:52:48 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:20278 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab0HaJwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 05:52:47 -0400
X-SpamScore: 11
X-BigFish: VPS11(zzbb2cK98dNzz1202hzzz32i2a8h5bep5bfs43h63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0L80GJA-01-UN0-02
X-M-MSG: 
Date: Tue, 31 Aug 2010 11:47:34 +0200
From: Robert Richter <robert.richter@amd.com>
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] x86: oprofile: fix oprofile_arch_init behaviour on
 failure
Message-ID: <20100831094734.GA22783@erda.amd.com>
References: <1283107921-21464-1-git-send-email-will.deacon@arm.com>
 <1283107921-21464-2-git-send-email-will.deacon@arm.com>
 <1283107921-21464-3-git-send-email-will.deacon@arm.com>
 <1283107921-21464-4-git-send-email-will.deacon@arm.com>
 <20100830090929.GU22783@erda.amd.com>
 <1283244880.645.17.camel@e102144-lin.cambridge.arm.com>
 <20100831090518.GZ22783@erda.amd.com>
 <1283247089.4063.2.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1283247089.4063.2.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.08.10 05:31:29, Will Deacon wrote:
> Ok, great. The commit comment might need tweaking for the first
> patch now that the x86 code remains unchanged.

Ok, will change this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

