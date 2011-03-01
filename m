Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1CAHPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 02:15:36 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50865 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab1CAHPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 02:15:35 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6271"; a="77061037"
Message-ID: <4D6C9D12.8090207@codeaurora.org>
Date: Tue, 01 Mar 2011 12:45:30 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stepan Moskovchenko <stepanm@codeaurora.org>
CC: davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] msm: iommu: Rework clock logic and add IOMMU bus
 clock control
References: <1298599242-21971-2-git-send-email-stepanm@codeaurora.org> <1298937782-28725-1-git-send-email-stepanm@codeaurora.org>
In-Reply-To: <1298937782-28725-1-git-send-email-stepanm@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On 3/1/2011 5:33 AM, Stepan Moskovchenko wrote:
> Clean up the clock control code in the probe calls, and add
> support for controlling the clock for the IOMMU bus
> interconnect. With the (proper) clock driver in place, the
> clock control logic in the probe function can be made much
> cleaner since it does not have to deal with the placeholder
> driver anymore.
> 
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
> ---
> v2: Use resource_size.

Looks good to me.

Reviewed-by: Trilok Soni <tsoni@codeaurora.org>

---Trilok Soni
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
