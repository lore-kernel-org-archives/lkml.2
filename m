Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab0ITIAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 04:00:25 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:2462 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752476Ab0ITIAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 04:00:24 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1432N98dN4015Lzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L91CWA-02-6RZ-02
X-M-MSG: 
Date: Mon, 20 Sep 2010 10:00:10 +0200
From: Robert Richter <robert.richter@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR
 error
Message-ID: <20100920080010.GM13563@erda.amd.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284087065-32722-3-git-send-email-ying.huang@intel.com>
 <20100913010248.GH21909@erda.amd.com>
 <1284343326.3269.70.camel@yhuang-dev.sh.intel.com>
 <20100916081806.GV13563@erda.amd.com>
 <1284682105.32373.11.camel@yhuang-dev>
 <20100917091454.GL13563@erda.amd.com>
 <1284855635.32373.298.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1284855635.32373.298.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.09.10 20:20:35, Huang Ying wrote:
> > If I am not wrong the only real functional change is to rip out the
> > edac handler. So, just introduce the final names with your renaming in
> > patch #1 (and maybe make a comment in the commit message or change
> > patch order).
> 
> If I merge the 1/6 and 3/6, can you suggest a patch subject, "Add symbol
> definition for NMI magic constants and rename memory parity to PCI
> SERR"?

Yes, maybe we make the edac change a separate one.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

