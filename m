Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2GWCAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:00:52 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:45574 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab2GWCAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 22:00:51 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q6N20Zfa002244, This message is released by code: ctaloc0852
Message-ID: <500CB043.6000904@realsil.com.cn>
Date: Mon, 23 Jul 2012 10:00:35 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Rusty Russell <rusty@ozlabs.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] drivers/misc: Add realtek pci card reader driver
References: <1342691710-23164-1-git-send-email-wei_wang@realsil.com.cn> <87sjcnas8f.fsf@rustcorp.com.au>
In-Reply-To: <87sjcnas8f.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty:

Thank you.

I will fix it and resend all of the three patches

BR,
wwang


于 2012年07月20日 13:58, Rusty Russell 写道:
> On Thu, 19 Jul 2012 17:55:10 +0800, <wei_wang@realsil.com.cn> wrote:
>> From: Wei WANG <wei_wang@realsil.com.cn>
>>
>> Realtek PCI-E card reader driver adapts requests from upper-level
>> sdmmc/memstick layer to the real physical card reader.
>> +static int msi_en = 1;
>> +module_param(msi_en, int, S_IRUGO | S_IWUSR);
>> +MODULE_PARM_DESC(msi_en, "Enable MSI");
>> +
>> +static int adma_mode = 1;
>> +module_param(adma_mode, int, S_IRUGO | S_IWUSR);
>> +MODULE_PARM_DESC(adma_mode, "ADMA Mode");
> These seem like they should be bool?
>
> Cheers,
> Rusty.

