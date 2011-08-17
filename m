Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1HQOpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 10:45:44 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61092 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1HQOpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 10:45:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:date:
	mime-version:content-transfer-encoding:from:organization:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=vLD3dpjjJdZr9DEDoKI/WtgJKKRhhPMVyj9/RztPzVTJ4Eu08ku15ZglUacQByA17
	v+xRaqFjo6Q79op03tfRA==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Sergei Shtylyov" <sshtylyov@mvista.com>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Felipe Balbi" <balbi@ti.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
References: <4E4B9D9C.2010607@linutronix.de>
 <aeb2d1e4eb36e6a0265ed0e6c279e81880bbfef2.1313585187.git.mina86@mina86.com>
 <4E4BD1F9.4010805@ru.mvista.com>
Date: Wed, 17 Aug 2011 16:45:29 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Message-ID: <op.v0c4l3txvgw7ix@mnazarewicz-glaptop>
In-Reply-To: <4E4BD1F9.4010805@ru.mvista.com>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Michal Nazarewicz wrote:
>> @@ -1354,10 +1350,8 @@ static void make_qualifier (struct dev_data *dev)
>>   	memcpy (dev->rbuf, &qual, sizeof qual);
>>  }
>> -#endif
>>  -static int
>> -config_buf (struct dev_data *dev, u8 type, unsigned index)
>> +static int config_buf (struct dev_data *dev, u8 type, unsigned index)
>>  {
>>  	int		len;
>>  	int		hs = 0;

On Wed, 17 Aug 2011 16:36:41 +0200, Sergei Shtylyov <sshtylyov@mvista.com>  
wrote:
> WARNING: space prohibited between function name and open parenthesis '('
> #291: FILE: drivers/usb/gadget/inode.c:1354:
> +static int config_buf (struct dev_data *dev, u8 type, unsigned index)

This is actually also an unrelated white-space change so I'll just remove  
this
change.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
