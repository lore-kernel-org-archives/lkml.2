Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2BGLFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 06:05:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:1255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab2BGLFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 06:05:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104087308"
Message-ID: <4F310529.4020101@intel.com>
Date: Tue, 07 Feb 2012 13:04:09 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Chris Ball <cjb@laptop.org>, Pierre Ossman <pierre@ossman.eu>,
        lkml <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org,
        arindam.nath@amd.com, zhangfei.gao@gmail.com
Subject: Re: mmc sdhci mmcblk0: error -110 sending status command, retrying
References: <CAAJw_ZsryUFFFRCKdd9sQ7_38hjpVq37b6hhZDX5=qz8x1B+EQ@mail.gmail.com> <m2pqdr2tyq.fsf@bob.laptop.org> <CAAJw_Zv4Hk_kfc33xsVcdi-0_C6tsf_FD3sUx1JPDX_fZZMzeQ@mail.gmail.com> <4F30E19B.9020503@intel.com> <CAAJw_Zth+QM8OhMEWweBBek8QNW_9CseHSDuB-LCGrvwuqfV2A@mail.gmail.com>
In-Reply-To: <CAAJw_Zth+QM8OhMEWweBBek8QNW_9CseHSDuB-LCGrvwuqfV2A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/12 12:40, Jeff Chua wrote:
> On Tue, Feb 7, 2012 at 4:32 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> 
>> Looks like Caps_1: 0x00008073 means re-tuning mode 3.  Maybe the tuning is
>> not being done correctly.
> 
> What I can do to test it?

Tuning may be needed for UHS (ultra high speed).
Was there a message like:

	mmc0: new ultra high speed SDHC card
