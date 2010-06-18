Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab0FRCIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 22:08:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:47034 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab0FRCIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 22:08:53 -0400
Message-ID: <4C1AD5A8.1030203@windriver.com>
Date: Fri, 18 Jun 2010 10:10:48 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: jason.wessel@windriver.com, gregkh@suse.de, galak@kernel.crashing.org,
       bruce.ashfield@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: cpm_uart: implement the cpm_uart_early_write()
 function for console poll
References: <1276744420-7845-1-git-send-email-dongdong.deng@windriver.com> <20100617173101.GB24362@kroah.com>
In-Reply-To: <20100617173101.GB24362@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2010 02:08:22.0720 (UTC) FILETIME=[2101CC00:01CB0E8B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Jun 17, 2010 at 11:13:40AM +0800, Dongdong Deng wrote:
>> The cpm_uart_early_write() function which was used for console poll
>> isn't implemented in the cpm uart driver.
>>
>> Implementing this function both fixes the build and allows
>> kgdboc to work via the cpm uart.
> 
> So this is needed for the .35 release, right?  Any older kernel releases
> as well?

Yes, it is needed for the .35 release.

The cpm_uart_early_write() of cpm_uart was introduced at 2.6.27,
so this patch is needed from 2.6.27.

Thanks,
Dongdong

> 
> thanks,
> 
> greg k-h
> 

