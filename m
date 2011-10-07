Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892Ab1JGLML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:12:11 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:50474 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759838Ab1JGLMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:12:10 -0400
Message-ID: <4E8EDE57.3020702@ru.mvista.com>
Date: Fri, 07 Oct 2011 15:11:19 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
CC: balbi@ti.com, gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de> <20111006120830.GN1714@legolas.emea.dhcp.ti.com> <4E8EB6EE.8040700@sensortherm.de>
In-Reply-To: <4E8EB6EE.8040700@sensortherm.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07-10-2011 12:23, Klaus Schwarzkopf wrote:

>>> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
>>> index dd1571d..f623f3d 100644
>>> --- a/include/linux/usb/gadget.h
>>> +++ b/include/linux/usb/gadget.h
>>> @@ -15,6 +15,7 @@
>>> #ifndef __LINUX_USB_GADGET_H
>>> #define __LINUX_USB_GADGET_H
>>>
>>> +#include<linux/device.h>
>>
>> this is not part of $SUBJECT


> changed git message

1. This should have been a separate patch.
2. Refresh your tree -- this part have been changed long ago with the #include 
added.

WBR, Sergei

