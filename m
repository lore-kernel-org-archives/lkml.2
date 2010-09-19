Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab0ISAUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 20:20:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:19181 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab0ISAUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 20:20:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,387,1280732400"; 
   d="scan'208";a="608206604"
Subject: Re: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR
 error
From: Huang Ying <ying.huang@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100917091454.GL13563@erda.amd.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	 <1284087065-32722-3-git-send-email-ying.huang@intel.com>
	 <20100913010248.GH21909@erda.amd.com>
	 <1284343326.3269.70.camel@yhuang-dev.sh.intel.com>
	 <20100916081806.GV13563@erda.amd.com>
	 <1284682105.32373.11.camel@yhuang-dev>
	 <20100917091454.GL13563@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 08:20:35 +0800
Message-ID: <1284855635.32373.298.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 17:14 +0800, Robert Richter wrote:
> On 16.09.10 20:08:25, Huang Ying wrote:
> > On Thu, 2010-09-16 at 16:18 +0800, Robert Richter wrote:
> > > On 12.09.10 22:02:06, Huang Ying wrote:
> > > > > Haven't you introduced *_MEMPAR with patch 1/6?
> > > > 
> > > > Yes. And I suggest to rename it to *_SERR in this patch to reflect the
> > > > contemporary hardware better. I think they are two steps: naming the
> > > > magic number and changing the name of constant and function.
> > > 
> > > Hmm, I would rather avoid introducing a name and then immediatly
> > > renaming it again.
> > 
> > I split them into two patches because there is function named as
> > mem_parity_error already. The 1/6 names constants as *_MEMPAR to make it
> > consistent with mem_parity_error(). 3/6 rename both the constants,
> > function name and some string/comments to serr. Do you think this is
> > more clean?
> 
> If I am not wrong the only real functional change is to rip out the
> edac handler. So, just introduce the final names with your renaming in
> patch #1 (and maybe make a comment in the commit message or change
> patch order).

If I merge the 1/6 and 3/6, can you suggest a patch subject, "Add symbol
definition for NMI magic constants and rename memory parity to PCI
SERR"?

Best Regards,
Huang Ying


