Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1CRHmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 03:42:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42300 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab1CRHml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 03:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=XBEvzdboNlLkFL8RRJJaJIAA3Qe6FpahQ4NldLp729M3/BXhtElcN2p/1tYzA1INLI
         L0a4k5e/fHh+uGTCgX6DqTqg88r0/epbzTmOT1QTow/NbBT347sVLJAszxVlk8k0jGwn
         Bzcq/BEZfrbiN6fAHxBb5q3tiXOEjPL9wqZpI=
Message-ID: <4D830CEC.4040608@linaro.org>
Date: Fri, 18 Mar 2011 07:42:36 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <20110311165642.GA9996@kroah.com> <20110317214042.GQ31411@opensource.wolfsonmicro.com> <20110317214736.GA29014@kroah.com> <201103172333.01474.arnd@arndb.de> <20110317225328.GB31581@kroah.com> <4D8296D1.9060106@linaro.org> <20110317232503.GA14561@kroah.com>
In-Reply-To: <20110317232503.GA14561@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2011 11:25 PM, Somebody in the thread at some point said:
> On Thu, Mar 17, 2011 at 11:18:41PM +0000, Andy Green wrote:
>> On 03/17/2011 10:53 PM, Somebody in the thread at some point said:
>>
>>>> Not tested!
>>>>
>>>> Signed-off-by: Arnd Bergmann<arnd.bergmann@linaro.org>
>>>
>>> <snip>
>>>
>>> Very nice.
>>>
>>> Andy and Mark, would this patch work for you?
>>
>> You do realize this untested patch depends on 13 year old vapour
>> definition of general usb device tagging in Device Tree that does
>> not exist yet?
>
> As you get to create your own device tree for your board, it will then
> exist, right?

No, if you read Arnd's post you will find Device Tree does not support 
targeting USB devices yet, and if you further read the 1998 document he 
points to as the basis of actually implementing it, it seems to me at 
least it'll be a little project yet to do that on Linux side.

That is why his "very nice" patch is untested, it literally doesn't work 
as things stand so he is unable to test it.  Yes, you will also need a 
device tree for your board.  When you ask if it "works for me", the 
answer is it doesn't work for me, the author nor anybody else.

The Device Tree guys at first trashing and then co-opting this RFC has 
the tendency to make me sound like a Device Tree basher.  Actually I 
don't think it's evil so long as it reflects the reality and necessity 
that it is completely optional, there is an elephant in the room about 
that and how it competes with platform_data.  At the moment Device Tree 
is "all things to all men", and few things stay like that for long.

-Andy
