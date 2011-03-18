Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab1CRHtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 03:49:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53122 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab1CRHts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 03:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=Etvtxzq+1qVWx1qE5feeokRK//7mknOXAdn0AguQxhZRUSRWqwi8TVW7QWieCOhnrO
         gtfY+Rz/VENQWVg0WGKPAYozIsU3PKSWJO3oHpt/L5b7HqfybDOHkgsN7Jkkv4g6EXiJ
         qvrCMeVORCtpl3N/6pRJ6LdzGc+1F069LtPJg=
Message-ID: <4D830E97.4010403@linaro.org>
Date: Fri, 18 Mar 2011 07:49:43 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <20110311165642.GA9996@kroah.com> <20110317214042.GQ31411@opensource.wolfsonmicro.com> <20110317214736.GA29014@kroah.com> <201103172333.01474.arnd@arndb.de> <20110317232756.GA3148@angua.secretlab.ca>
In-Reply-To: <20110317232756.GA3148@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2011 11:27 PM, Somebody in the thread at some point said:

> The patch below also looks right to me.  I believe it also has the
> advantage of u-boot already knowing how to update the
> local-mac-address property at boot time.

In my (tested, working, complete) patch series, I allow platform_data 
based override of MAC at usbnet level, so all the drivers can benefit 
from it.

Is this not a case of "small thinking" from a Device Tree perspective 
that Arnd's patch only targets smsc95xx?  Or did I miss some 
disadvantage to allowing this functional configuration option at usbnet 
layer?

-Andy
