Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab1EPFQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 01:16:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52561 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1EPFQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 01:16:55 -0400
Message-ID: <78EB813416554F1A973EF20AA714ADF8@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: "Greg KH" <greg@kroah.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>,
        "Watkins, Melissa" <m-watkins@ti.com>, <sachi@mistralsolutions.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "open list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 08/11] tty: add pruss SUART driver
Date: Mon, 16 May 2011 10:47:18 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

>>> Say, if the driver is loaded as a module.
>>> If I allocate the sram in the platform code, how to I
>>> free it when the driver is unloaded. 
>> 
>> This is what I said in my last e-mail. What is
>> the issue you see with this approach?
>> 
>> | Thanks for the clarification. In this case, the driver
>> | should use platform callbacks to get/put fast fifo
>> | space. In case this callback is not populated by the
>> | platform or returns an error, the driver should fall
>> | back to allocating from DDR.
>> 
> 
> ok, so what you are suggesting is that I implement some
> callbacks (like .fifo_alloc, .fifo_dealloc) which can allocate
> memory using sram_alloc.
> My doubt is, if already such API's are there (by Russel) or you
> are suggesting to implement them.

I can add the fifo_alloc/dealloc as part of the suart platform_data,
Is that's what you are suggesting. If you may please point me out 
to any example. I am just not clear with this. 
