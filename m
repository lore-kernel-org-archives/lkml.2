Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0IMBaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 21:30:52 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:20893
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753530Ab0IMBau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 21:30:50 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zzbb2cK936eK1432N98dNzz1202hzz8275bh8275dh5eeePz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8NW75-02-CEZ-02
X-M-MSG: 
Date: Mon, 13 Sep 2010 03:30:41 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Peter Zijlstra <peterz@infradead.org>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/6] x86, NMI, Add symbol definition for NMI magic
 constants
Message-ID: <20100913013041.GH13563@erda.amd.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284151027.402.123.camel@laptop>
 <20100911105001.72b73ce8@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100911105001.72b73ce8@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.09.10 04:50:01, Andi Kleen wrote:
> On Fri, 10 Sep 2010 22:37:07 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, 2010-09-10 at 10:51 +0800, Huang Ying wrote:
> > > +       return inb(NMI_REASON_PORT);
> > 
> > I've always wondered, where is this magic stuff documented?
> 
> In the datasheet of the chipset. But sometimes you need
> to dig deeper to get a global picture including all chipsets.

It is also here:

 http://support.amd.com/us/Embedded_TechDocs/43009_sb7xx_rrg_pub_1.00.pdf
 2.3.3.1.1 IO-Mapped Control Registers

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

