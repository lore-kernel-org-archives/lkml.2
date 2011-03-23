Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab1CWQeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:34:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54292 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab1CWQeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=aWKl6DNHVfF9h/VybbX/GYYa8VcUr2dFjQNutFWbpLm48J8goSrHY84/46lm/99GDl
         duCY4krVReonjJkvNXB/xDI14Q6Bss2q3/mP3yTrmHpjWX79vOQ1dRmCkMO8eYNuLodU
         6E/jCG9yW9PS/FfyKio0RvsZaHJaA06G9Ai4s=
Message-ID: <4D8A20F8.2080409@linaro.org>
Date: Wed, 23 Mar 2011 16:34:00 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org> <201103231132.02690.arnd@arndb.de> <20110323150852.GE6284@kroah.com> <201103231712.06184.arnd@arndb.de> <20110323162251.GA9367@kroah.com>
In-Reply-To: <20110323162251.GA9367@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 04:22 PM, Somebody in the thread at some point said:

>>    In case of smsc95xx, we *know* that it's ethernet and not two-host,
>>    there is no reasonable doubt about this. The code almost makes sense
>>    on generic cdc devices, but not for anything else.
>
> Ok, let's fix it up and see who complains :)

OK... what approach are you alright with being used to signal the fix up 
selection of interface name in usbnet?  Flag set in async platform_data 
from board definition file as in the existing tested patches is OK?

-Andy
