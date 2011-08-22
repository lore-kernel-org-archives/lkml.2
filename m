Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab1HVI3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 04:29:09 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:52478 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab1HVI27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 04:28:59 -0400
Message-ID: <4E521325.9090606@atmel.com>
Date: Mon, 22 Aug 2011 10:28:21 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.20) Gecko/20110804 Lightning/1.0b2 Thunderbird/3.1.12
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-mmc@vger.kernel.org,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] mmc: atmel rework for next
References: <4E4A8E73.7050705@atmel.com> <m24o1dnxjg.fsf@bob.laptop.org>
In-Reply-To: <m24o1dnxjg.fsf@bob.laptop.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 19/08/2011 19:03, Chris Ball :
> Hi,
> 
> On Tue, Aug 16 2011, Nicolas Ferre wrote:
>> Hi Chris,
>>
>> Please pull from:
>>
>> git://github.com/at91linux/linux-2.6-at91.git nfe/mmc_atmel
>>
>> This is a series that reworks the atmel-mci driver for a future merge of both at91_mci and atmel-mci drivers. Those patches have been discussed on the mailing-list.
>> I added a tiny at91_mci patch also sent last week.
> 
> Thanks, all looks good -- pushed to mmc-next with some commit message
> rewording.  Please wrap your commit messages to 75 cols in future, so
> that they're viewable in "git log" without wrapping.

Thanks Chris for this. I will pay attention to line wrapping.

> I'll repeat your warning text from one of the commit messages here for
> the broader audience:
> 
>     Warning: at91rm9200 is not supported, to support it we need to use
>     swab32 on data but I have no board to test it.

Best regards,
-- 
Nicolas Ferre

