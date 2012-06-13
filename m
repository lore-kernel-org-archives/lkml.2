Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab2FMIDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:03:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:39316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab2FMIDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:03:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="152384981"
Message-ID: <4FD84936.5080006@linux.intel.com>
Date: Wed, 13 Jun 2012 16:03:02 +0800
From: "Xiao, Hui" <hui.xiao@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [BUGFIX] ACPI, APEI, Avoid too much error reporting in runtime
References: <1339471219-4057-1-git-send-email-ying.huang@intel.com> <4FD6C310.3060507@kernel.org>
In-Reply-To: <4FD6C310.3060507@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/6/12 12:18, Len Brown wrote:
> applied.
> 
> thanks,
> -Len Brown, Intel Open Source Technology Center
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Hi all,

I've also encountered the similar bug:
  [Firmware Bug]: APEI: Invalid bit width + offset in GAR [0x1121a5000/64/0/3/0]
during einj test. 

Besides Ying's fix patch, I think its a regression caused by incorrect bit width + offset check condition introduced by commit v3.3-5-g15afae6. I've written a fix patch for it and will send it in a separate mail soon.

Thanks,
-Hui

