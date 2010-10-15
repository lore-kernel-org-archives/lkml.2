Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0JONbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:31:43 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:33136
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755275Ab0JONbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:31:42 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);(null);(null)
X-WSS-ID: 0LAC2WI-01-2DJ-02
X-M-MSG: 
Date: Fri, 15 Oct 2010 15:31:31 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: oprofile-list <oprofile-list@lists.sf.net>,
        lkml <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] oprofile: make !CONFIG_PM function stubs static inline
Message-ID: <20101015133131.GE5969@erda.amd.com>
References: <1287149245-31169-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1287149245-31169-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.10.10 09:27:25, Robert Richter wrote:
> Make !CONFIG_PM function stubs static inline and remove section
> attribute.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>

I have applied the patch already to the oprofile tree.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

