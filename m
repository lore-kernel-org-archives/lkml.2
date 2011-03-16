Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1CPRA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:00:57 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:58685
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362Ab1CPRAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:00:52 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1432N98dN4015Lzz1202hzzz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LI5TWW-02-3R6-02
X-M-MSG: 
Date: Wed, 16 Mar 2011 18:00:14 +0100
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>
Subject: Re: [PATCH] oprofile: Allow setting EDGE/INV/CMASK for Intel
 counter events
Message-ID: <20110316170014.GR31407@erda.amd.com>
References: <1299870748-13319-1-git-send-email-andi@firstfloor.org>
 <20110316150450.GO31407@erda.amd.com>
 <20110316152757.GA12845@tassilo.jf.intel.com>
 <20110316154553.GQ31407@erda.amd.com>
 <20110316165634.GA11094@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110316165634.GA11094@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.03.11 12:56:34, Andi Kleen wrote:
> > Shouldn't something like the follwing work (assuming the umask table
> > is modified)?
> > 
> >  opcontrol --event SOME_EVENT:100000:0x00800000 ...
> 
> I think there was some problem with this when I tried it.
> 
> Besides I'm more interested in using named events for this;
> the raw numbers are quite evil. So this needs new user space
> in any case.

Ok, in this case we can use also /extra. So I am fine with this too.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

