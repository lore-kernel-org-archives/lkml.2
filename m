Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab0IAXxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 19:53:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26900 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0IAXxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 19:53:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6092"; a="52944310"
Message-ID: <4C7EE786.9040302@codeaurora.org>
Date: Wed, 01 Sep 2010 16:53:42 -0700
From: Gregory Bean <gbean@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] msm: Featurize gpiomux.
References: <1283383572-15635-1-git-send-email-gbean@codeaurora.org> <1283384144.21049.26.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1283384144.21049.26.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2010-09-01 at 16:26 -0700, Gregory Bean wrote:
>> Featurize gpiomux so that systems like 7x00 which do not wish to use it
>> do not have to be saddled with the configuration tables.
>>
>
> What happens without this?

Not much, until the gpiolib hooks come along (see my next two patches), 
and then everybody would be forced to have the gpiomux config table 
without the featurization.  And for those folks not using it, that's a 
big empty table full of annoying nothingness...

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
