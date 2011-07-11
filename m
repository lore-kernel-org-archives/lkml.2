Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1GKJsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 05:48:00 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:39158 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1GKJr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:47:59 -0400
Message-ID: <4E1AC69A.6060307@atmel.com>
Date: Mon, 11 Jul 2011 11:47:06 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-mmc@vger.kernel.org, hans-christian.egtvedt@atmel.com,
        kernel@avr32linux.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, u.kleine-koenig@pengutronix.de
Subject: Re: [PATCH V3] MMC: PM: add suspend/resume in atmel-mci
References: <1309530754.4373.3.camel@hcegtvedt.norway.atmel.com>	<1309779505-25509-1-git-send-email-nicolas.ferre@atmel.com> <m2iprbkw6v.fsf@bob.laptop.org>
In-Reply-To: <m2iprbkw6v.fsf@bob.laptop.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 09/07/2011 22:58, Chris Ball :
> Hi,
> 
> On Mon, Jul 04 2011, Nicolas Ferre wrote:
>> Take care of slots while going to suspend state.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>> V3: take care of each slot SUSPENDED state
>>     (adding a status bit in the slot "flags")
>> V2: move to pm_ops
> 
> Thanks, I've merged v3 of this patch for mmc-next/3.1 with Felipe's

You mean v4, I have checked: everything is ok.

> Reviewed-by, and your [2/2] kconfig change.

Perfect, thanks a lot Chris!
-- 
Nicolas Ferre

