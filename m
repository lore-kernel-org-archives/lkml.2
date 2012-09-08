Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab2IHAtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:49:41 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22275 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759522Ab2IHAti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:49:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6828"; a="232032848"
Message-ID: <504A9621.8020301@codeaurora.org>
Date: Fri, 07 Sep 2012 17:49:37 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Bryan Huntsman <bryanh@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 8/9] ARM: msm: Add DT support for 8960
References: <1346873339-10927-1-git-send-email-sboyd@codeaurora.org> <1346873339-10927-9-git-send-email-sboyd@codeaurora.org> <20120907225853.GA21585@codeaurora.org>
In-Reply-To: <20120907225853.GA21585@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/12 15:58, David Brown wrote:
> On Wed, Sep 05, 2012 at 12:28:58PM -0700, Stephen Boyd wrote:
>
>> +DT_MACHINE_START(MSM8960_DT, "Qualcomm MSM (Flattened Device Tree)")
> The description string should specify the general name of what this is
> suspporting.  Right now, with these patches, it would list
>
>   Qualcomm MSM (Flattened Device Tree)
>
> twice as the two targets we support (and isn't helpful when you see
> which one it picks).  I'd put the "MSM" name by itself without
> thinking about it too much.  It wasn't that confusing, since there was
> only one at the time.
>
> Perhaps make the 8660 one "Qualcomm MSM8660 (Flattened Device Tree)"
> and the 8960 one "Qualcomm MSM8960 (Flattened Device Tree)"
>
> I realize that the chip numbers are a bit confusing, so probably best
> to pick a canonical name for the description.
>

I think we don't need to do anything. Basically machine name is always
"Qualcomm MSM (Flattened Device Tree)" but then the model name in the
devicetree blob says a more descriptive value "Qualcomm MSM8960 CDP" or
"Qualcomm MSM8660 SURF", etc. All this info is printed in the kernel log
upon boot:

[    0.000000] Machine: Qualcomm MSM (Flattened Device Tree), model: Qualcomm MSM8960 CDP


In fact, it should be possible to put the two dt board files together at
some point if we can somehow drive the map_io routine from devicetree.
In this case we could even have the same machine descriptor used for
both machines.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

