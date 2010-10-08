Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab0JHNvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:51:45 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:31613 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab0JHNvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:51:44 -0400
Message-ID: <4CAF21CE.5000901@atmel.com>
Date: Fri, 08 Oct 2010 15:51:10 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Anders Larsen <al@alarsen.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Andrew Victor <avictor.za@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: AT91: Fix power-saving in idle-mode on 926T processors
References: <20101007194415.GA24709@alarsen.net> <20101008122918.GA30252@game.jcrosoft.org>
In-Reply-To: <20101008122918.GA30252@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

Le 08/10/2010 14:29, Jean-Christophe PLAGNIOL-VILLARD :
> On 21:44 Thu 07 Oct     , Anders Larsen wrote:
>> According to Atmel, their 926T processors (AT91 post RM9200) requires
>> 'Wait for Interrupt' mode be entered right after disabling the processor clock
>> in order to minimise current consumption when idle, so do both provided we're
>> not running on a 920T (an RM9200).
>>
>> Furthermore, get rid of the #ifndef CONFIG_DEBUG_KERNEL, since arch_idle()
>> can be turned off completely with the kernel parameter 'nohlt'.
>>
>> Signed-off-by: Anders Larsen <al@alarsen.net>
>> Cc: Andrew Victor <avictor.za@gmail.com>
> please rebase against this branch
> 
> git://github.com/at91linux/linux-2.6-at91.git branch for-rmk

This patch seems already in your "master" branch
(5c189208b606a85b4e97109af70d59f10a42fdfd).

Do you want me to rebase this patch or do you mange merging with "AT91:
fix use of clock disable on idle for AT91x40 devices"
(cb809b1a5ebffca8cf0314b788919989e8e4ab5f) ?
already in your "devel" and "devel-stable" branches?

Best regards,
-- 
Nicolas Ferre

