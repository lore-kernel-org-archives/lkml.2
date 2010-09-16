Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab0IPISg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 04:18:36 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:52360
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171Ab0IPISe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 04:18:34 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zzbb2cK1432N98dN179dNzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L8TZ25-02-BLT-02
X-M-MSG: 
Date: Thu, 16 Sep 2010 10:18:06 +0200
From: Robert Richter <robert.richter@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR
 error
Message-ID: <20100916081806.GV13563@erda.amd.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284087065-32722-3-git-send-email-ying.huang@intel.com>
 <20100913010248.GH21909@erda.amd.com>
 <1284343326.3269.70.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1284343326.3269.70.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.09.10 22:02:06, Huang Ying wrote:
> > Haven't you introduced *_MEMPAR with patch 1/6?
> 
> Yes. And I suggest to rename it to *_SERR in this patch to reflect the
> contemporary hardware better. I think they are two steps: naming the
> magic number and changing the name of constant and function.

Hmm, I would rather avoid introducing a name and then immediatly
renaming it again.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

