Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab1ECG22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 02:28:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46013 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab1ECG21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 02:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Gx2vr7nCMzmz7NQZl/TzEHDNnWxbQYk6TNuquzCkYoji+egmOmAgCNsrfpXAzp7EU4
         P0MFtJ5WbJpNvys4RNQ6Z7XxhJYlb4Wn1qS1ovDCJ+qS1fgsod+E9Wg48Oovkv8iLT1u
         EGyd6O+13IykwCedlVaXJR3Aq+4r3geKjZmJE=
Message-ID: <4DBFA152.8000709@gmail.com>
Date: Tue, 03 May 2011 14:31:46 +0800
From: =?UTF-8?B?5bq35YmR5paM?= <kjbmail@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
CC: linux-kernel@vger.kernel.org, dan.j.williams@intel.com
Subject: Re: Can I/OAT DMA engineer access PCI MMIO space
References: <4DBA8F30.2060206@gmail.com>	 <1304316260.1589.2.camel@vkoul-udesk3>  <4DBF66C0.9020600@gmail.com> <1304395926.1589.27.camel@vkoul-udesk3>
In-Reply-To: <1304395926.1589.27.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> yes, I had used 'ioremap_nocache' to map the IO memory and I can use
>> memcpy to copy data to this region. The async_tx should have been
>> correctly configured as
>> I can use aync_memcpy to copy data between different system memory address.
> Then you should be using memcpy_toio() and friends
>
Do you mean that if I have mapped the mmio, I can' use I/OAT dma 
transfer to this region any more?
I can use memcpy to copy data, but it consumes lots of cpu as PCI access 
is too slow.
If I can use i/oat dma and asyc_tx api to do the job, the performance 
should be imporved.
Thanks
