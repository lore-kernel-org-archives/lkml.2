Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab2KWBLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 20:11:53 -0500
Received: from intranet.asianux.com ([58.214.24.6]:42849 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab2KWBLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 20:11:51 -0500
X-Spam-Score: -100.7
Message-ID: <50AECD8D.5000206@asianux.com>
Date: Fri, 23 Nov 2012 09:12:45 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: arnd@arndb.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] drivers/char: in hpet.c, check for hdp->hd_nirqs
References: <50ADAF18.7090404@asianux.com> <20121122182451.GD25392@kroah.com>
In-Reply-To: <20121122182451.GD25392@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年11月23日 02:24, Greg KH 写道:
> On Thu, Nov 22, 2012 at 12:50:32PM +0800, Chen Gang wrote:
>> Hello Arnd Bergmann, Greg Kroah-Hartman
>>
>>   in drivers/char/hpet.c:1009
>>     I suggest to add check for hdp->hd_nirqs whether equal or larger than 32 (HPET_MAX_TIMERS)
>>       the type of irqp->interrupt_count is u8 (include/acpi/acrestyp.h:349)
>>       the type of hdp->hd_irq is "unsigned int hd_irq[HPET_MAX_TIMERS]" (include/linux/hpet.h:99)
>>       #define HPET_MAX_TIMERS (32) (include/linux/hpet.h:38)
>>
>>   additional information:
>>     acpi_register_gsi() not check the boundaries of how many irqs (at least, unlimited for u8).
>>     maybe (only maybe) the irqp->interrupt_count is always less than 32 by hardware limitation.
>>     I do not know whether it is a bug, so as a suggestion.
> 
> Care to send a patch that implements this?
> 
> thanks,
> 
> greg k-h
> 
> 

  yes, I will do.

  please help to check what I shall send (also OK to check by another one, I understand you are busy).

  please waiting for a while.

  thanks.

-- 
Chen Gang

Asianux Corporation
