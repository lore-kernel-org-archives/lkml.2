Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1BHKtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:49:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:28502 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab1BHKtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:49:33 -0500
Date: Tue, 08 Feb 2011 19:49:11 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: [PATCH v4] dw_mmc: Add Synopsys DesignWare mmc host driver.
In-reply-to: <AANLkTikTxjbkA9d9WjVNm9bC3bPLQDndwSXCxp3jOLKS@mail.gmail.com>
To: Will Newton <will.newton@gmail.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-arm-kernel@lists.infradead.org
Message-id: <4D511FA7.4040207@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
References: <AANLkTi=0RtvsGX+Q3goL3mdG6oKeNidYtiudTZ8ZTpRP@mail.gmail.com>
 <20101208115510.GD10998@console-pimps.org>
 <AANLkTi=KqOa-MRQiptCtZGvoafRCgULfE3QFs=hmGpdi@mail.gmail.com>
 <AANLkTi=PpTi1_JO9Q=ph7w9Jim8iXMf9LbCfmEkWuo-h@mail.gmail.com>
 <20101209064751.GA21128@void.printf.net>
 <AANLkTimMgrawcndvUTYYjq9BGFqs-sbRsZkwVQ0Uvhvb@mail.gmail.com>
 <20101209160157.GA28586@void.printf.net>
 <AANLkTim3Rj2tTbqvT8nM4L=p=Wx8bdOnGq=EDv+cs02g@mail.gmail.com>
 <20101211192320.GA24430@void.printf.net>
 <AANLkTik7cMwgwXR1zK44HXC+1YtzpU3_zW2GUjcBMi8X@mail.gmail.com>
 <4D354752.3030401@samsung.com>
 <AANLkTi=SEXYk9B6N6RGmLKAx_QF6sybgHMVVpEo8mcp8@mail.gmail.com>
 <4D50E4DD.4030500@samsung.com>
 <AANLkTikTxjbkA9d9WjVNm9bC3bPLQDndwSXCxp3jOLKS@mail.gmail.com>
X-OriginalArrivalTime: 08 Feb 2011 10:49:14.0824 (UTC)
 FILETIME=[D3C9AC80:01CBC77D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will

I'm probing dw_mmc on Samsung SoC...

So i have some board specific data..

But i didn't want to add board specific data in dw_mmc.c
I want to use get_cd()/get_wd()/init()...So i asked to you..:)

If i need not the data information, i will not append them..
you're right, maybe "struct dw_mci" need not..(just example)

And i think that need card_detect irq-handler function..if we use pdata->init..isn't? :)

In future, if i need your help, can i ask to you?

Onemore...Did you test the dw_mmc..?
If you can answer, i want to know the performance..

Will Newton wrote:
> On Tue, Feb 8, 2011 at 6:38 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>> Hi Will..
>>
>> I need your help for your code..
>>
>> In dw_mmc.h, exist some function pointer..
>>
>> int *get_ro(u32 slot_id);
>> int *get_cd(u32 slot_id);
>> ...
>>
>> Just only need slot_id??
>> If i need the "struct dw_mci", could i append the parameter?
> 
> Yes, that should be possible. However I would like to reduce the
> number of places the whole struct dw_mci
> is passed around if possible, as the whole struct is usually not
> needed and it exposes some driver internals.
> 
> Which part of struct dw_mci do you need in the callback?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

