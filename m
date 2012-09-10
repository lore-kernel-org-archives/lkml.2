Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab2IJMG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:06:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36931 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab2IJMGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:06:22 -0400
Message-ID: <504DD7B5.40908@ti.com>
Date: Mon, 10 Sep 2012 17:36:13 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/2] ARM: da850/omap-l138: Add EVM specific code for
 VPIF to work
References: <1345471731-31678-1-git-send-email-prabhakar.lad@ti.com> <1345471731-31678-3-git-send-email-prabhakar.lad@ti.com> <504A2C7D.1090702@ti.com> <CA+V-a8sGhrTLJnthX+nZESvJfaHFTV=x06eXjQOwwCZwGBxkPQ@mail.gmail.com> <504DB28D.3070005@ti.com>
In-Reply-To: <504DB28D.3070005@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On Monday 10 September 2012 02:57 PM, Sekhar Nori wrote:
> Hi Prabhakar,
> 
> On 9/7/2012 11:04 PM, Prabhakar Lad wrote:
>> On Fri, Sep 7, 2012 at 10:48 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> 
>>>> +static struct vpif_subdev_info da850_vpif_capture_sdev_info[] = {
>>>> +#if defined(CONFIG_DA850_UI_SD_VIDEO_PORT)
>>>
>>> You agreed to get rid of these multiple ifdefs but you have not fixed that.
>>>
>> I have merged the top one, at later stage when we go  ahead and add sensor
>> support then we would have require to have define two
>> da850_vpif_capture_sdev_info
>> so to avoid it I have kept this one.
> 
> Lets get to that when we actually add sensor support. It might make
> sense then. Right now, there is no reason to have them.
> 
Ok I'll fix it for v3.

Regards,
--Prabhakar

> Thanks,
> Sekhar
> 

