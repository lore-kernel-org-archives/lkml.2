Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab0KXSM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:12:56 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58646 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab0KXSMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:12:55 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6177"; a="64207821"
Message-ID: <4CED55A6.5090608@codeaurora.org>
Date: Wed, 24 Nov 2010 10:12:54 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: James Jones <jajones@nvidia.com>
CC: Nicolas Pitre <nico@fluxnic.net>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Fix find_next_zero_bit and related assembly
References: <1289524615-22484-1-git-send-email-jajones@nvidia.com>	<alpine.LFD.2.00.1011231625380.9313@xanadu.home> <201011231528.25668.jajones@nvidia.com>
In-Reply-To: <201011231528.25668.jajones@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2010 03:28 PM, James Jones wrote:
> On Tuesday 23 November 2010 13:26:47 Nicolas Pitre wrote:
>> On Thu, 11 Nov 2010, James Jones wrote:
>>> The find_next_bit, find_first_bit, find_next_zero_bit
>>> and find_first_zero_bit functions were not properly
>>> clamping to the maxbit argument at the bit level. They
>>> were instead only checking maxbit at the byte level.
>>> To fix this, add a compare and a conditional move
>>> instruction to the end of the common bit-within-the-
>>> byte code used by all the functions and be sure not to
>>> clobber the maxbit argument before it is used.
>>>
>>> Signed-off-by: James Jones <jajones@nvidia.com>
>>> Tested-by: Stephen Warren <swarren@nvidia.com>
>> Reviewed-by: Nicolas Pitre <nicolas.pitre@linaro.org>
>>
>> Please send to RMK's patch system.
> Thanks for the review.  It's already in the patch system, but I updated the 
> entry to include your reviewed-by line.

Should this be sent to the stable tree too?
