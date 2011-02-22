Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab1BVNXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 08:23:07 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39889 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1BVNXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 08:23:06 -0500
Message-ID: <01ADA340BA2E4A62BBFC1E4FB630B380@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Sergei Shtylyov" <sshtylyov@mvista.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <sachi@mistralsolutions.com>, "Russell King" <linux@arm.linux.org.uk>,
        "Kevin Hilman" <khilman@deeprootsystems.com>, <nsekhar@ti.com>,
        "open list" <linux-kernel@vger.kernel.org>, <m-watkins@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-13-git-send-email-subhasish@mistralsolutions.com> <4D55860E.3090908@mvista.com> <B2D7D72494BB443F80DA08E22323999B@subhasishg> <4D639C18.9010309@mvista.com>
In-Reply-To: <4D639C18.9010309@mvista.com>
Subject: Re: [PATCH v2 12/13] da850: pruss SUART platform specific additions.
Date: Tue, 22 Feb 2011 18:54:18 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, will do.

--------------------------------------------------
From: "Sergei Shtylyov" <sshtylyov@mvista.com>
Sent: Tuesday, February 22, 2011 4:50 PM
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>; 
<sachi@mistralsolutions.com>; "Russell King" <linux@arm.linux.org.uk>; 
"Kevin Hilman" <khilman@deeprootsystems.com>; <nsekhar@ti.com>; "open list" 
<linux-kernel@vger.kernel.org>; <m-watkins@ti.com>; 
<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 12/13] da850: pruss SUART platform specific 
additions.

> Hello.
>
> On 22-02-2011 12:18, Subhasish Ghosh wrote:
>
>> I could not follow your recommendations clearly, are you suggesting this:
>
>> int __init da8xx_register_pruss(struct da8xx_pruss_devices *pruss_device)
>> {
>> #ifdef CONFIG_SERIAL_PRUSS_SUART_MODULE
>> int ret;
>>
>> ret = clk_add_alias(NULL, "da8xx_pruss_uart.1",
>> NULL, &da850_mcasp_device.dev);
>> if (ret < 0)
>> return ret;
>> #endif
>> da8xx_pruss_dev.dev.platform_data = pruss_device;
>> return platform_device_register(&da8xx_pruss_dev);
>> }
>
>    Yes. But still better would be to wrap clk_add_alias() into a function 
> of its own (defining it empty if CONFIG_SERIAL_PRUSS_SUART_MODULE is not 
> defined).
>
> WBR, Sergei 

