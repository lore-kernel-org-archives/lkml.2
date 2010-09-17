Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab0IQJPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 05:15:30 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:38571
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967Ab0IQJPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 05:15:20 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zzbb2cK936eK1432N98dN179dNzz1202hzz8275dhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8VWCT-02-0QP-02
X-M-MSG: 
Date: Fri, 17 Sep 2010 11:14:54 +0200
From: Robert Richter <robert.richter@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR
 error
Message-ID: <20100917091454.GL13563@erda.amd.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284087065-32722-3-git-send-email-ying.huang@intel.com>
 <20100913010248.GH21909@erda.amd.com>
 <1284343326.3269.70.camel@yhuang-dev.sh.intel.com>
 <20100916081806.GV13563@erda.amd.com>
 <1284682105.32373.11.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1284682105.32373.11.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.09.10 20:08:25, Huang Ying wrote:
> On Thu, 2010-09-16 at 16:18 +0800, Robert Richter wrote:
> > On 12.09.10 22:02:06, Huang Ying wrote:
> > > > Haven't you introduced *_MEMPAR with patch 1/6?
> > > 
> > > Yes. And I suggest to rename it to *_SERR in this patch to reflect the
> > > contemporary hardware better. I think they are two steps: naming the
> > > magic number and changing the name of constant and function.
> > 
> > Hmm, I would rather avoid introducing a name and then immediatly
> > renaming it again.
> 
> I split them into two patches because there is function named as
> mem_parity_error already. The 1/6 names constants as *_MEMPAR to make it
> consistent with mem_parity_error(). 3/6 rename both the constants,
> function name and some string/comments to serr. Do you think this is
> more clean?

If I am not wrong the only real functional change is to rip out the
edac handler. So, just introduce the final names with your renaming in
patch #1 (and maybe make a comment in the commit message or change
patch order).

-Robert

> 
> Best Regards,
> Huang Ying
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

