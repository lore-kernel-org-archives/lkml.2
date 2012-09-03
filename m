Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2ICOtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 10:49:18 -0400
Received: from mail.dce.bg ([46.40.123.75]:53840 "HELO mail.bulcrypt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932260Ab2ICOtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 10:49:17 -0400
Message-ID: <5044C36B.2010300@dce.bg>
Date: Mon, 03 Sep 2012 17:49:15 +0300
From: Alexander <alexander@dce.bg>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: file Documentation/usb/usbmon.txt should list the .config settings
References: <50446CA1.7040904@dce.bg> <4905024.kP3GZmCRKy@linux-lqwf.site>
In-Reply-To: <4905024.kP3GZmCRKy@linux-lqwf.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2012 12:23 PM, Oliver Neukum wrote:
> On Monday 03 September 2012 11:38:57 Alexander wrote:
>> Please indicate in the Documentation/usb/usbmon.txt file that the kernel
>> needs to be compiled with:
>>
>> CONFIG_DEBUG_KERNEL=y
>> CONFIG_DEBUG_FS=y
>> CONFIG_USB_MON=y
>> CONFIG_USB_DEVICEFS=y
> Are you saying tht the modular options have been broken?
>
> 	Regards
> 		Oliver
>
>
Ok what I meant is "if you want to build usbmon support into the kernel 
then it needs to be compiled with ..."
I think it will be useful, especially for embedded developers to have 
this info in the usbmon doc file.
Sorry about this confusion...

Thanks,
Alexander
