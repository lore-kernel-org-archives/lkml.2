Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab2JAFKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 01:10:18 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:55037 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab2JAFKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 01:10:14 -0400
MIME-Version: 1.0
In-Reply-To: <5068779A.20402@mvista.com>
References: <1348836795-4783-1-git-send-email-kishon@ti.com>
	<1348836795-4783-7-git-send-email-kishon@ti.com>
	<5068779A.20402@mvista.com>
Date: Mon, 1 Oct 2012 10:40:12 +0530
Message-ID: <CAAe_U6Lt-+HQ5ZZ3xGsfhCqcOewWGprBCYc31qbZE_uUK7VtvA@mail.gmail.com>
Subject: Re: [PATCH 6/6] usb: dwc3: core: add dt support for dwc3 core
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Sep 30, 2012 at 10:17 PM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
>
> On 28-09-2012 14:53, Kishon Vijay Abraham I wrote:
>
>> Added dwc3 support for dwc3 core and update the documentation with
>> device tree binding information.
>>
>> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
>
> [...]
>
>
>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
>> index 08a5738..0c17a7a 100644
>> --- a/drivers/usb/dwc3/core.c
>> +++ b/drivers/usb/dwc3/core.c
>
> [...]
>
>> @@ -602,11 +601,22 @@ static int __devexit dwc3_remove(struct
>> platform_device *pdev)
>>         return 0;
>>   }
>>
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id of_dwc3_matach[] = {
>
>
>     I guess you meant 'of_dwc3_match' here and below?

indeed.. will re-post the patch..

Thanks
Kishon
