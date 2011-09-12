Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1ILJEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 05:04:50 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:54966 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1ILJEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 05:04:49 -0400
Message-ID: <4E6DCAF5.50607@atmel.com>
Date: Mon, 12 Sep 2011 11:03:49 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Josef Holzmayr <holzmayr@rsi-elektrotechnik.de>,
        Nico Erfurth <ne@erfurth.eu>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Subject: Re: [GIT PULL] at91: changes for next
References: <4E6A09D0.40800@atmel.com> <201109102306.58340.arnd@arndb.de>
In-Reply-To: <201109102306.58340.arnd@arndb.de>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 10/09/2011 23:06, Arnd Bergmann :
> On Friday 09 September 2011, Nicolas Ferre wrote:
>> Can you please pull the following changes since commit ddf28352b80c86754a6424e3a61e8bdf9213b3c7:
>>
>>   Linux 3.1-rc5 (2011-09-04 15:45:10 -0700)
>>
>> They are available in the git repository at:
>>   git://github.com/at91linux/linux-at91.git  at91-next
>>
>> They have been present on linux-arm-kernel for some time and where recently added in linux-next.
>> Stephen resolved some trivial conflicts relatives to the removal of a board file (Cf:
>> https://lkml.org/lkml/2011/9/9/96 ).
>>
>> A series by Thomas is touching the USB subsystem: ohci-at91.c but as most of changes are in the at91 directory, it makes more sense to take them in arm-soc.
> 
> Hi Nicolas,
> 
> I've resumed pulling patches and uploaded them to git.linaro.org while
> master.kernel.org continues to be unavailable.
> 
> I've decided to split your branch into two separate branches 'board'
> and 'devel' to better match the code from other soc trees in a way
> that I can send forward to Linus. Please check that the split trees
> actually make sense, and tell me if that's ok for you or if you would
> prefer them split differently.

I have checked and It is perfect for me.

Thanks a lot Arnd, bye,
-- 
Nicolas Ferre

