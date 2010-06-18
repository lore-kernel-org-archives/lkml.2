Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab0FRNiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:38:05 -0400
Received: from core.signal11.us ([64.251.29.136]:56477 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab0FRNiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:38:00 -0400
Message-ID: <4C1B76B5.10806@signal11.us>
Date: Fri, 18 Jun 2010 09:37:57 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: Re: [PATCH] HID: Documentation for hidraw
References: <1276832283-12084-1-git-send-email-alan@signal11.us> <20100618115738.c3dfb81b.ospite@studenti.unina.it>
In-Reply-To: <20100618115738.c3dfb81b.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jun 18 09:37:59 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c1b76b7284451132650553
X-DSPAM-Factors: 27,
	Received*26+177, 0.01000,
	the+device, 0.01000,
	To*Ospite+<ospite, 0.01000,
	References*git, 0.01000,
	of, 0.01000,
	User-Agent*Mozilla/5.0, 0.01000,
	References*alan+signal11.us>, 0.01000,
	Received*ESMTP, 0.01000,
	User-Agent*rv+1.9.1.9), 0.01000,
	Received*(c+76, 0.01000,
	Received*242.hsd1.fl.comcast.net+[76.26.177.242]), 0.01000,
	User-Agent*US+rv, 0.01000,
	References*send+email, 0.01000,
	From*<alan, 0.01000,
	would, 0.01000,
	ioctl, 0.01000,
	References*1+git, 0.01000,
	References*email+alan, 0.01000,
	Content-Type*8859+1, 0.01000,
	User-Agent*U, 0.01000,
	return, 0.01000,
	User-Agent*Thunderbird/3.0.4, 0.01000,
	Cc*vger.kernel.org+linux, 0.01000,
	Subject*for, 0.01000,
	User-Agent*en+US, 0.01000,
	Date*18, 0.01000,
	Received*core.signal11.us, 0.01000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2010 05:57 AM, Antonio Ospite wrote:
>
> Maybe both hidraw.txt and hiddev.txt can be moved to
> Documentation/hid/?
>
>    
Antonio,

You and Jiri seem to have the same idea on this one. Sounds good to me.
>> +
>> +HIDIOCGRAWNAME(len): Get Raw Name
>> +This ioctl returns a string containing the vendor and product strings of
>> +the device.  The returned string is Unicode, UTF-8 encoded.
>> +
>>      
> Is the encoding specified in the HID spec?
>    
USB returns strings to the host as Unicode, UTF16LE encoded. The kernel 
converts them to UTF-8. See usb_string() in drivers/usb/core/message.c.

>
> Just a very minimal remark, maybe the code should follow the kernel
> coding style (early return on error, no braces for one line conditional
> blocks) even if it is a userspace application. Being it in the
> kernel Documentation I assume people reading it would be used to kernel
> style more.
>
>    
Good point. I'll run the style check on it and fix it up.

Alan.

