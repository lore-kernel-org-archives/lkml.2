Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab1CQXSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:18:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49360 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab1CQXSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:18:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=Ii5f35vLrSbdaL51ww4pano6XZQfrgBlT6ByLDcbVzgMA1jrylM3OqmWHA4KepLLGb
         E3nTt5ech2+zxvUQnxlUr19qsqinVAOFha/Mu3kPRmHf1TNKCpV58L1+EkpywKR5Oepj
         6RPOgcrDXABsBC417Xsmc5YPUOriXAFDzfsew=
Message-ID: <4D8296D1.9060106@linaro.org>
Date: Thu, 17 Mar 2011 23:18:41 +0000
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
References: <20110311165642.GA9996@kroah.com> <20110317214042.GQ31411@opensource.wolfsonmicro.com> <20110317214736.GA29014@kroah.com> <201103172333.01474.arnd@arndb.de> <20110317225328.GB31581@kroah.com>
In-Reply-To: <20110317225328.GB31581@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2011 10:53 PM, Somebody in the thread at some point said:

>> Not tested!
>>
>> Signed-off-by: Arnd Bergmann<arnd.bergmann@linaro.org>
>
> <snip>
>
> Very nice.
>
> Andy and Mark, would this patch work for you?

You do realize this untested patch depends on 13 year old vapour 
definition of general usb device tagging in Device Tree that does not 
exist yet?

-Andy
