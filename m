Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1BPXlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 18:41:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35801 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab1BPXlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 18:41:16 -0500
Message-ID: <4D5C602E.9050106@zytor.com>
Date: Wed, 16 Feb 2011 15:39:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Daniel Drake <dsd@laptop.org>, cbou@mail.ru, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        dilinger@queued.net, dmitry.torokhov@gmail.com
Subject: Re: [PATCH v3] olpc_battery: convert to platform device
References: <20110216222820.487AE9D401C@zog.reactivated.net> <1297896277.3011.5.camel@macbook.infradead.org>
In-Reply-To: <1297896277.3011.5.camel@macbook.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 02:44 PM, David Woodhouse wrote:
> On Wed, 2011-02-16 at 22:28 +0000, Daniel Drake wrote:
>>
>> +static int __init add_common_platform_devices(void)
>> +{
>> +       struct platform_device *pdev;
>> +
>> +       pdev = platform_device_register_simple("olpc-battery", -1, NULL, 0);
>> +       if (IS_ERR(pdev))
>> +               return PTR_ERR(pdev);
>> +
>> +       return 0;
>> +}
>> + 
> 
> Still kind of sucks that you have to do this, and can't bind to
> something in the device-tree.
> 

Any reason you can't include a device tree in the OLPC kernel?

	-hpa

