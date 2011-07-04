Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab1GDPSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:18:09 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:22244 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab1GDPSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:18:05 -0400
Message-ID: <4E11D99D.7040005@atmel.com>
Date: Mon, 04 Jul 2011 17:17:49 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, patrice.vilchez@atmel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for 3.0] AT91: Change nand buswidth logic to match hardware
 default configuration
References: <1309515924-22531-1-git-send-email-nicolas.ferre@atmel.com> <201107041625.25972.arnd@arndb.de> <4E11D123.9070409@atmel.com> <201107041713.23982.arnd@arndb.de>
In-Reply-To: <201107041713.23982.arnd@arndb.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 04/07/2011 17:13, Arnd Bergmann :
> On Monday 04 July 2011, Nicolas Ferre wrote:
>>> In this case, studying the patch more closely shows that it's
>>> very harmless, but I'd rather not have to look that closely.
>>
>> Well, in fact it is a fix against what was introduced in a 3.0 patch
>> which I found to be wrong.
>> The reason because I do not want to be in next kernel is the fact that
>> it can puzzle the user (people that want to use kernel without changing
>> the system_rev between 2.6.39 -> 3.0 and again revert their changes for
>> 3.0 -> 3.1).
>>
>>> Am I correct that the bug is a regression against 2.6.39?
>>
>> No, in fact it was introduced during 3.0 early -rc.
> 
> That's what I mean by 'regression against 2.6.39': it was working in 2.6.39,
> but later kernels are broken without this fix.

Absolutely (here broken = not easily understandable by user).

Bye,
-- 
Nicolas Ferre

