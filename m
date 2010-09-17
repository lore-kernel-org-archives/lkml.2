Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab0IQAI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 20:08:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:16842 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab0IQAI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 20:08:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,378,1280732400"; 
   d="scan'208";a="838406595"
Subject: Re: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR
 error
From: Huang Ying <ying.huang@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100916081806.GV13563@erda.amd.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	 <1284087065-32722-3-git-send-email-ying.huang@intel.com>
	 <20100913010248.GH21909@erda.amd.com>
	 <1284343326.3269.70.camel@yhuang-dev.sh.intel.com>
	 <20100916081806.GV13563@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 08:08:25 +0800
Message-ID: <1284682105.32373.11.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 16:18 +0800, Robert Richter wrote:
> On 12.09.10 22:02:06, Huang Ying wrote:
> > > Haven't you introduced *_MEMPAR with patch 1/6?
> > 
> > Yes. And I suggest to rename it to *_SERR in this patch to reflect the
> > contemporary hardware better. I think they are two steps: naming the
> > magic number and changing the name of constant and function.
> 
> Hmm, I would rather avoid introducing a name and then immediatly
> renaming it again.

I split them into two patches because there is function named as
mem_parity_error already. The 1/6 names constants as *_MEMPAR to make it
consistent with mem_parity_error(). 3/6 rename both the constants,
function name and some string/comments to serr. Do you think this is
more clean?

Best Regards,
Huang Ying


