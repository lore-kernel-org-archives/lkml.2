Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab1CRXdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 19:33:19 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:62463 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab1CRXdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 19:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=r/XZSmx0dm0xPmZCscPVQHQQk696Kp0GdRf4RQaFW4suoWzqPvOp0eWqN9VSAC0Q0I
         O4begjFdoQ6ZzJdbba/Yek7DbDXosNvDc3qfKvKKusgLYDUtMTV7nziR6gNo8h+RKdY/
         nL90e9VOGgc8xk/V8QL3r3F1JYtLK202oCjJc=
Message-ID: <4D83EBB5.1010705@linaro.org>
Date: Fri, 18 Mar 2011 23:33:09 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <20110311165642.GA9996@kroah.com> <201103181600.09877.arnd@arndb.de> <4D839BCD.6030202@linaro.org> <201103182106.13888.arnd@arndb.de> <4D83CF8C.3020605@linaro.org> <20110318232553.GA11422@opensource.wolfsonmicro.com>
In-Reply-To: <20110318232553.GA11422@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2011 11:25 PM, Somebody in the thread at some point said:
> On Fri, Mar 18, 2011 at 09:33:00PM +0000, Andy Green wrote:
>
>> Well: Greg was also reduced to explaining that device renaming in
>> userland was decided "a long time ago".  It's not argumentation, it is
>> an appeal to an alleged tradition.
>
> The story with device renaming is fairly simple - nobody could agree on
> what the ideal names should be and different userlands ended up wanting
> different things so rather than try to keep everyone happy the kernel
> picked the simplest policy possible and let userland override it to its
> heart's content.
>
>> You think that striving away to create this Device Tree description of a
>> specific board and maintaining it in a bootloader is LESS work somehow
>> that registering platform devices in an array in the board definition
>> file?  I think not.
>
> It's more the fact that it can be distributed separately to the kernel
> which reduces the pressure to mainline the basic board description stuff
> for ongoing maintinance.

However that was not the claim.

The claim was that there is a burden with platform_data that it is 
"inflexible", which I dealt with separately, and -->

''...you have to write code for each new board you want to support,
something that we've generally moved away from in Linux a decade
ago. ''

You very much "have to write code for each new board you want to 
support" with Device Tree, so this point is bogus when contrasting the 
attributes of platform_data against Device Tree.

-Andy
