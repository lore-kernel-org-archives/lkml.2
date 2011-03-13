Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab1CMNV2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 09:21:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48394 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab1CMNVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 09:21:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=FU5Bk3zx9nyvgC9xb8Qo95VuYpCTX6qPuk/iZQqf61/COe5aSZkhnyQu9QE1PfrU49
         kp8jj4bHZV72ClFGfhGIxEJ++TCQZx9O7ryyYZl8atap7bSpXrStbcLVoIMpm2RirUiC
         lj4AdQN5q+rqvZ1OnvR/qTKhiSieZ+dlgcW7w=
Message-ID: <4D7CC4D0.90305@linaro.org>
Date: Sun, 13 Mar 2011 13:21:20 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 3/4] PLATFORM: Introduce async platform_data attach
 api
References: <20110312222633.27020.19543.stgit@otae.warmcat.com> <201103131141.07380.rjw@sisk.pl> <4D7CB15A.6030203@linaro.org> <201103131353.54612.rjw@sisk.pl>
In-Reply-To: <201103131353.54612.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 12:53 PM, Somebody in the thread at some point said:

>>>> This _really_ should just use the device tree stuff, that is what it is
>>>> for, please don't duplicate it here in a not-as-flexible way.
>>>
>>> I agree.
>>>
>>> @Andy: If it doesn't work for you for some reason, please let us know the
>>> usage case that is not covered (in detail).
>>
>> The device tree stuff does not yet exist in a workable way,
>> platform_data is established everywhere except USB bus.  Device tree
>> brings in bootloader version as a dependency: this method doesn't.
>
> It is not the same device tree we are talking about. :-)
>
> I mean device hierarchy (and I guess Greg meant the same).

I see.  Elsewhere on the previous thread people were proposing to use 
New Shiny Device Tree, hence the confusion.

I am using the old style device tree to walk the device's parent path. 
What were you guys actually suggesting to do differently via the device 
tree then that's cleaner?

-Andy
