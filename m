Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031090Ab2CAOGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 09:06:47 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:26031 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031001Ab2CAOGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 09:06:44 -0500
Message-ID: <4F4F8267.5030408@atmel.com>
Date: Thu, 01 Mar 2012 15:06:31 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] at91: fixes for DMA registration (3.3-rc)
References: <4F4F49E1.4020902@atmel.com> <201203011149.42948.arnd@arndb.de> <4F4F7254.9060306@atmel.com> <201203011403.11369.arnd@arndb.de>
In-Reply-To: <201203011403.11369.arnd@arndb.de>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2012 03:03 PM, Arnd Bergmann :
> On Thursday 01 March 2012, Nicolas Ferre wrote:
>> As discussed on the mailing-list, we experience an out-of-sync situation
>> between the DMA controller driver and the related code in AT91 devices files.
>>
>> Those two patches already queued for 3.4 are correcting the problem that we found on
>> the current 3.3-rc kernels. I have tested that the DMA driver is registering well
>> with those fixes applied.
>>
>> Can you please pull them in a "fixes" branch and send them to Linus before 3.3-final?
> 
> Hi Nicolas,
> 
> I've just sent a pull request for bug fixes yesterday, so I'll wait
> until Linus has pulled that one and probably a few days before I
> send another one.

Sure.

> I have applied it to the fixes branch now but not updated the
> tag that I sent him.

Ok, thanks a lot for your quick help.

Best regards,
-- 
Nicolas Ferre
