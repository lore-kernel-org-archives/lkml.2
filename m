Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab1CRUCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:02:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57319 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab1CRUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:02:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=mjdlL3iAOQFAsR5X6VEUbbKaB8XIc4yDJZTTjFa4aZ8Cmw+DN2YMbXFYWdYd/BPRfV
         iGRumHtpv8AompPddEwKGlmLEJDONlTcCFB3JmmjJAwLf6LJC9p2d5fVIgnYlc3JY1TD
         AZptOqYPxb4bSDkUVaEhsZ2zMv2bcLDSOar3A=
Message-ID: <4D83BA4F.8050301@linaro.org>
Date: Fri, 18 Mar 2011 20:02:23 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: David Anders <x0132446@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg KH <greg@kroah.com>, Grant Likely <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D83A25C.804@ti.com> <20110318182518.GA2271@opensource.wolfsonmicro.com>
In-Reply-To: <20110318182518.GA2271@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2011 06:25 PM, Somebody in the thread at some point said:

Hi -

>> if you grep in drivers/net you will find a wide range of network
>> devices that use the random_ether_addr() function:
>
> This is a slightly different case to the one where device tree is most
> useful which is the case where there is a MAC assigned to the system but
> it's been stored in an alternative location and needs to be programmed
> into the NIC by software.

 From an earlier discussion in IRC, I know David's point is the presence 
of so many calls to random_ether_addr() suggests the "crap, there is no 
EEPROM" state can be reached by all those drivers.

In which case, they are all potential consumers of a MAC "stored in an 
alternative location and needs to be programmed into the NIC by 
software" solution, which he also thinks is needed.

-Andy
