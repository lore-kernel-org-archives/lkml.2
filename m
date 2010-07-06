Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab0GFQ4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 12:56:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63071 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab0GFQ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 12:56:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6035"; a="46479790"
Message-ID: <4C336020.3090206@codeaurora.org>
Date: Tue, 06 Jul 2010 09:56:00 -0700
From: Greg Bean <gbean@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] msm: gpio: Add set_wake support to msm7200a-gpio's
 irq_chip.
References: <1278185128-29161-1-git-send-email-gbean@codeaurora.org> <1278434857.27490.2.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1278434857.27490.2.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Add power-management and irq_chip hooks to allow configuration
>> of msm-gpio irq lines as wakeup sources.
>
> What level of correlation is there between power management and the wake
> up hooks? Just irq_masks ?

When the system sleeps, gpio-based irqs which are not configured as wake-up 
sources are disabled in the controller hardware to prevent latching and 
unwanted wakeups.

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
