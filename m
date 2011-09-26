Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1IZJWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:22:40 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:28924 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1IZJWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:22:39 -0400
Message-ID: <4E804440.7030709@atmel.com>
Date: Mon, 26 Sep 2011 11:22:08 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Josh Wu <josh.wu@atmel.com>,
        linux-kernel@vger.kernel.org, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 2/2] at91: add Atmel ISI and ov2640 support on sam9m10/sam9g45
 board.
References: <1316664661-11383-1-git-send-email-josh.wu@atmel.com> <1316664661-11383-2-git-send-email-josh.wu@atmel.com> <Pine.LNX.4.64.1109220911500.11164@axis700.grange> <20110924052609.GI29998@game.jcrosoft.org>
In-Reply-To: <20110924052609.GI29998@game.jcrosoft.org>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 24/09/2011 07:26, Jean-Christophe PLAGNIOL-VILLARD :
> On 09:35 Thu 22 Sep     , Guennadi Liakhovetski wrote:
>> On Thu, 22 Sep 2011, Josh Wu wrote:
>>
>>> This patch
>>> 1. add ISI_MCK parent setting code when add ISI device.
>>> 2. add ov2640 support on board file.
>>> 3. define isi_mck clock in sam9g45 chip file.
>>>
>>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>>> ---
>>>  arch/arm/mach-at91/at91sam9g45.c         |    3 +
>>>  arch/arm/mach-at91/at91sam9g45_devices.c |  105 +++++++++++++++++++++++++++++-
>>>  arch/arm/mach-at91/board-sam9m10g45ek.c  |   85 ++++++++++++++++++++++++-
>>>  arch/arm/mach-at91/include/mach/board.h  |    3 +-
>>
>> Personally, I think, it would be better to separate this into two patches 
>> at least: one for at91 core and one for the specific board, but that's up 
>> to arch maintainers to decide.
>>
>> You also want to patch arch/arm/mach-at91/at91sam9263_devices.c, don't 
>> you?
> agreed

No, I am not sure. The IP is not the same between 9263 and 9g45/9m10. So
this inclusion will not apply.

Best regards,
-- 
Nicolas Ferre

