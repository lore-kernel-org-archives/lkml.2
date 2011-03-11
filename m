Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab1CKQUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:20:53 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55812 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1CKQUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:20:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=L7I15TPDKV27UjUo4lZIYAgyalQSO9Djw70l8tM0KVmBiEM45K9sEnurH4VJSq9UJ9
         oMa+8Yr2ESyn847hdaJfFav6pfV9Avob1a1vKFJ2WcFRF3X3mA6dj6mtEw9DU0xycL4Y
         gtIhqaPpq635HjhK8MlOnYkBQLLi3TNS9eSws=
Message-ID: <4D7A4BDE.7050206@linaro.org>
Date: Fri, 11 Mar 2011 16:20:46 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org> <20110311160815.GA7426@kroah.com>
In-Reply-To: <20110311160815.GA7426@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 04:08 PM, Somebody in the thread at some point said:
> On Fri, Mar 11, 2011 at 09:50:32AM +0000, Andy Green wrote:
>> The particular use that suggested this is on Panda, it would be
>> ideal to be able to set a flag in the usb device's platform data
>> that forces it to be named eth%d since it's a hardwired asset on the
>> board with an RJ45 socket.
>
> If you _really_ need to name your network devices in a specific order,
> then use the userspace tools we already have to do this.  That is what
> they were created for, why ignore them?

I think maybe discussion of this use-case, its usbnet specificity, and 
the alternative options to achieve that have derailed discussion about 
what I was actually asking.

Is it true that for on-board devices, it can sometimes be legitimate and 
useful to be able to deliver platform_data from the board file through 
to stuff on a USB bus, same as you would for memory mapped, I2C, other 
busses?

Or is that it since it is USB, it can never be useful or legitimate, no 
matter what different kind of wired-up on-board USB device it is, to 
have the board definition file configure the driver for that instantiation?

-Andy
