Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab1CRW51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:57:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54880 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab1CRW5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:57:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=RY5aoo7KXMUyNS1zS4EZhjuEBCd4VIP4cQUMJ/nYEOwLUjf10furhXMvRYAamJIuvw
         3qeTSvG36IKhsVeJGIGKIs0E5Iuiy+uEobr4pDBF6oFfN/6jhNJgSnJ/Ltm1hJ7KmAXJ
         itSF7ztFtkh0A1Axg9xtGWen2+kGpug0Q7ckA=
Message-ID: <4D83E34B.3040808@linaro.org>
Date: Fri, 18 Mar 2011 22:57:15 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <20110311165642.GA9996@kroah.com>	 <20110317214042.GQ31411@opensource.wolfsonmicro.com>	 <20110317214736.GA29014@kroah.com> <201103172333.01474.arnd@arndb.de>	 <20110317225328.GB31581@kroah.com> <4D8296D1.9060106@linaro.org>	 <20110317232503.GA14561@kroah.com>  <4D830CEC.4040608@linaro.org> <1300488849.22236.1296.camel@pasglop>
In-Reply-To: <1300488849.22236.1296.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2011 10:54 PM, Somebody in the thread at some point said:
> On Fri, 2011-03-18 at 07:42 +0000, Andy Green wrote:
>>
>> No, if you read Arnd's post you will find Device Tree does not support
>> targeting USB devices yet, and if you further read the 1998 document he
>> points to as the basis of actually implementing it, it seems to me at
>> least it'll be a little project yet to do that on Linux side.
>
> You are getting seriously full of sh*t here. Read again what Arnd said
> rather than twisting it to try to make your point.
>
> The age of the OF binding document for USB has no relevance. The fact

OK, thanks for pointing out I am full of shit.

-Andy
