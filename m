Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab2HYSVY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 14:21:24 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:38832 "EHLO
	homiemail-a45.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751082Ab2HYSVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 14:21:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=XUpTh/rpSkl18U/2HtNzpYJBwkIMCRzWo6qnpjYbqlnVMvr2TghJmJ2gBb4Mn
	OIXSI8AHtGJCMIYcc8zYol+QM6JhesQTNL595x54vCMBftLzpDyQOEgRCyFbELlj
	ZYy/X0KjqX4e6bHxEyCrAuw/R/1frqjOUl5T+CNrHPh/mU=
Message-ID: <5039179D.6010909@shealevy.com>
Date: Sat, 25 Aug 2012 14:21:17 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120703 Thunderbird/11.0.1
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Add support for Apple vendor-specific devices
References: <1345915686-3915-1-git-send-email-rydberg@euromail.se> <50390B54.4040706@shealevy.com> <20120825174342.GA4057@polaris.bitmath.org>
In-Reply-To: <20120825174342.GA4057@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 08/25/2012 01:43 PM, Henrik Rydberg wrote:
> On Sat, Aug 25, 2012 at 01:28:52PM -0400, Shea Levy wrote:
>> Hello,
>>
>> On 08/25/2012 01:28 PM, Henrik Rydberg wrote:
>>> +	/* Apple-specific (Broadcom) devices */
>>> +	{ USB_VENDOR_AND_INTERFACE_INFO(0x05ac, 0xff, 0x01, 0x01) },
>>> +
>>>
>> Would this subsume https://lkml.org/lkml/2012/8/22/689 ?
> Yes, it will make 05ac:821d work as well. If you are able to test it
> successfully, we can append the commit message and add your Tested-by.

I'm getting a build error due to lack of USB_VENDOR_AND_INTERFACE_INFO 
macro when patching 3.5.2 with that patch. Which kernel tree should I 
patch with this patch to test?

> Thanks,
> Henrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,
Shea
