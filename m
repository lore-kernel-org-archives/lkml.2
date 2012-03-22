Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030600Ab2CVPLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 11:11:24 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35771 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab2CVPLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 11:11:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6656"; a="172514134"
Message-ID: <4F6B4112.7060404@codeaurora.org>
Date: Thu, 22 Mar 2012 20:41:14 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Ravi Kumar V <kumarrav@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, linux-arm-msm@vger.kernel.or,
        linux-kernel@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/2] DMAEngine: Add DMAEngine driver based on old MSM
 ADM DMA APIs
References: <1332413882-8456-1-git-send-email-kumarrav@codeaurora.org> <4F6B11DC.9090401@metafoo.de>
In-Reply-To: <4F6B11DC.9090401@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 3/22/2012 5:19 PM, Lars-Peter Clausen wrote:
>
> Same comment as before. This is supposed to return either a valid descriptor
> or NULL, but not an ERR_PTR.

Ravi has just posted v5 addressing your comments. Please check.

---Trilok Soni
--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
