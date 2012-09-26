Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab2IZSgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:36:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60470 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662Ab2IZSgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:36:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6847"; a="241521554"
Message-ID: <50634B17.8050204@codeaurora.org>
Date: Wed, 26 Sep 2012 11:36:07 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pankaj Jangra <jangra.pankaj9@gmail.com>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH 09/10] ARM: msm: Make proc_comm clock control into a platform
 driver
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org> <1348194419-11486-10-git-send-email-sboyd@codeaurora.org> <CADTbHxoNdmAWaZ1dDYz_8zFr6xDxp8NYHPGF_WjYbeTWLmuMQw@mail.gmail.com>
In-Reply-To: <CADTbHxoNdmAWaZ1dDYz_8zFr6xDxp8NYHPGF_WjYbeTWLmuMQw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/12 11:03, Pankaj Jangra wrote:
>
>> +
>> +static int __devinit msm_clock_pcom_probe(struct platform_device *pdev)
>> +{
>> +       struct pcom_clk_pdata *pdata = pdev->dev.platform_data;
> Should'nt it be const struct?

Sure. Fixed.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

