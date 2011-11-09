Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab1KIIjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:39:01 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:57759 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756085Ab1KIIi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:38:59 -0500
Message-ID: <4EBA3BFB.5030304@stericsson.com>
Date: Wed, 9 Nov 2011 09:38:19 +0100
From: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "balbi@ti.com" <balbi@ti.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jaswinder.singh@linaro.org" <jaswinder.singh@linaro.org>,
        "21cnbao@gmail.com" <21cnbao@gmail.com>,
        "rmk@arm.linux.org.uk" <rmk@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 1/2] USB-musb: move to dma_transfer_direction
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com> <1318610350-23335-1-git-send-email-vinod.koul@linux.intel.com> <20111109060919.GD23337@legolas.emea.dhcp.ti.com>
In-Reply-To: <20111109060919.GD23337@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 07:09 AM, Felipe Balbi wrote:
> On Fri, Oct 14, 2011 at 10:09:09PM +0530, Vinod Koul wrote:
>> fixup usage of dma direction by introducing dma_transfer_direction,
>> this patch moves usb/musb driver to use new enum
>>
>> Signed-off-by: Vinod Koul<vinod.koul@linux.intel.com>
>> Cc: Felipe Balbi<balbi@ti.com>
>> Cc: Greg Kroah-Hartman<gregkh@suse.de>
> This looks ok to me:
>
> Acked-by: Felipe Balbi<balbi@ti.com>
>
> Mian, if you agree with this patch, please reply with your Acked-by

Looks ok to me as well:

Acked-by: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>


Thanks,

-- 
Mian Yousaf Kaukab

