Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1GXWks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 18:40:48 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59728 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1GXWkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 18:40:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6417"; a="105607186"
Message-ID: <4E2C9F6E.9070207@codeaurora.org>
Date: Sun, 24 Jul 2011 15:40:46 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Set proper TEXT_OFFSET for newer MSMs
References: <1311529149-20213-1-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.00.1107241548170.1762@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1107241548170.1762@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2011 12:56 PM, Nicolas Pitre wrote:
> On Sun, 24 Jul 2011, Stephen Boyd wrote:
>> +static void __init msm7x30_fixup(struct machine_desc *desc, struct tag *tag,
>> +			 char **cmdline, struct meminfo *mi)
>> +{
>> +	for (; tag->hdr.size; tag = tag_next(tag))
>> +		if (tag->hdr.tag == ATAG_MEM && tag->u.mem.start == 0x200000)
>> +			tag->u.mem.start = 0;
>> +}
> Don't you need to also increase tag->u.mem.size  by 2MB ?

Thanks. I was fixated on the start address.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

