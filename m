Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1JCIJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 04:09:29 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:60183 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1JCIJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 04:09:24 -0400
Message-ID: <4E896DA2.6040906@atmel.com>
Date: Mon, 03 Oct 2011 10:09:06 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] at91 fixes for 3.1
References: <4E838F77.2040705@atmel.com> <201109302217.13937.arnd@arndb.de>
In-Reply-To: <201109302217.13937.arnd@arndb.de>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2011 10:17 PM, Arnd Bergmann :
> On Wednesday 28 September 2011, Nicolas FERRE wrote:
>> Here is a couple of fixes that may be included in 3.1-final.
>> The Kconfig modification will allow to select the PWM driver for SAM9G45 
>> SoC. This will also benefit to stable kernels.
>> The new defconfig for SAM9G45 family will allow us to better monitor the 
>> health of this port through automatic compilation mechanism. I find it 
>> interesting to have it included the sooner.
>>
>> The pull is based on the following changes since commit 
>> a102a9ece5489e1718cd7543aa079082450ac3a2:
>>
>>    Linux 3.1-rc8 (2011-09-27 15:48:34 -0700)
>>
>> are available in the git repository at:
>>    git://github.com/at91linux/linux-at91.git at91-fixes
> 
> Hi Nicolas,
> 
> I've pulled them into the fixes branch now. My feeling however is that
> these by themselves are not reason enough to send a pull request to Linus,
> so they will probably be the first thing I send in the 3.2 merge window,
> unless some other important fixes appear.

Ok, that makes sense.

Thanks Arnd, bye,
-- 
Nicolas Ferre

