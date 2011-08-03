Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1HCNzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:55:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44887 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab1HCNzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:55:13 -0400
MIME-Version: 1.0
In-Reply-To: <20110803134302.GP11080@legolas.emea.dhcp.ti.com>
References: <1312378755-7919-1-git-send-email-per.forlin@stericsson.com>
	<20110803134302.GP11080@legolas.emea.dhcp.ti.com>
Date: Wed, 3 Aug 2011 15:55:12 +0200
Message-ID: <CAJ0pr1806gGNvDK-WDuRKwg8nU_qnMZWZ9icA4oh1jxsErj1Yw@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: cppi: fix build errors due to DBG and missing
 musb variable
From: Per Forlin <per.forlin@linaro.org>
To: balbi@ti.com
Cc: Per Forlin <per.forlin@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 August 2011 15:43, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, Aug 03, 2011 at 03:39:15PM +0200, Per Forlin wrote:
>> From: Per Forlin <per.forlin@linaro.org>
>>
>> Replace DBG with dev_dbg add fix invalid access of musb->controller.
>> With this patch cppi_dma builds successfully.
>>
>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>> Cc: <stable@kernel.org>
>
> applied, thanks
>
I forgot to mention. This patch is not tested on target because I
don't have any davinci board. None the less this driver is more useful
now when it builds.

Regards,
Per
