Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab0FRC4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 22:56:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:53650 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab0FRC4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 22:56:04 -0400
Message-ID: <4C1AE0CE.3040901@windriver.com>
Date: Fri, 18 Jun 2010 10:58:22 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Greg KH <greg@kroah.com>, jason.wessel@windriver.com,
       galak@kernel.crashing.org, bruce.ashfield@windriver.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: cpm_uart: implement the cpm_uart_early_write()
 function for console poll
References: <1276744420-7845-1-git-send-email-dongdong.deng@windriver.com> <20100617173101.GB24362@kroah.com> <4C1AD5A8.1030203@windriver.com> <20100618023758.GA10393@suse.de>
In-Reply-To: <20100618023758.GA10393@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2010 02:55:58.0964 (UTC) FILETIME=[C7760B40:01CB0E91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Jun 18, 2010 at 10:10:48AM +0800, DDD wrote:
>> Greg KH wrote:
>>> On Thu, Jun 17, 2010 at 11:13:40AM +0800, Dongdong Deng wrote:
>>>> The cpm_uart_early_write() function which was used for console poll
>>>> isn't implemented in the cpm uart driver.
>>>>
>>>> Implementing this function both fixes the build and allows
>>>> kgdboc to work via the cpm uart.
>>> So this is needed for the .35 release, right?  Any older kernel releases
>>> as well?
>> Yes, it is needed for the .35 release.
>>
>> The cpm_uart_early_write() of cpm_uart was introduced at 2.6.27,
>> so this patch is needed from 2.6.27.
> 
> So no one has noticed that the driver doesn't build at all since the .27
> kernel release?  Over 2 years?  I hardly think that it's a rush to fix
> it over the next few weeks then :)
>

Hi greg,

The build error just happens when enable the CONFIG_CONSOLE_POLL option.

> I'll go queue it up.

Thanks,

Dongdong

> 
> thanks,
> 
> greg k-h
> 

