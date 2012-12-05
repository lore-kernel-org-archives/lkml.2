Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2LECfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 21:35:03 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27717 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2LECfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 21:35:00 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6916"; a="11827579"
Message-ID: <50BEB2D3.7000101@codeaurora.org>
Date: Tue, 04 Dec 2012 18:34:59 -0800
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <robherring2@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dt/platform: Use cell-index for device naming if available
References: <1352508532-19241-1-git-send-email-stepanm@codeaurora.org>    <509F0E56.6080806@gmail.com>    <CACxGe6s3gJ4fmhn9VBd1Fq8bH5S0_ejmE=KqVjYn20bT42wQ_Q@mail.gmail.com> <554191d69bc21a4b133fb876df84ff89.squirrel@www.codeaurora.org> <50A1B50B.4020509@codeaurora.org> <20121115161020.3205E3E194B@localhost> <50A70485.90302@codeaurora.org> <20121120161957.7CE973E102F@localhost>
In-Reply-To: <20121120161957.7CE973E102F@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 8:19 AM, Grant Likely wrote:
> What if instead we added something like OF_ALIASES to the uevent
> attribute? Then userspace would have access to all the aliases for a
> device. Heck, even a shell script can parse the uevent attribute. There
> is also precedence for exporting OF data using a uevent. This is from
> the versatile device tree support:
>
> # cat /sys/devices/amba.0/uevent
> OF_NAME=amba
> OF_FULLNAME=/amba
> OF_COMPATIBLE_0=arm,amba-bus
> OF_COMPATIBLE_N=1
> MODALIAS=of:NambaT<NULL>Carm,amba-bus

This sounds like a good idea. I have just sent out a new patch to do 
this. I followed the OF_COMPATIBLE uevent convention for listing the 
aliases, but I can follow another convention if someone objects.

Steve

-- 
  The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
  hosted by The Linux Foundation
