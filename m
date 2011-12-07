Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab1LGSnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:43:37 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54862 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab1LGSnf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:43:35 -0500
MIME-Version: 1.0
In-Reply-To: <20111207130517.GA22946@xps8300>
References: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
	<1323105820-25946-3-git-send-email-felipe.contreras@nokia.com>
	<20111207130517.GA22946@xps8300>
Date: Wed, 7 Dec 2011 20:43:35 +0200
Message-ID: <CAMP44s2FV=Dtquq+HuhB7+0fTi9YwiY-4YcSf1XdB=OwDHYULA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Revert "ARM: RX-51: Enable isp1704 power on/off"
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Heikki Krogerus <krohei@gmail.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 3:05 PM, Heikki Krogerus <krohei@gmail.com> wrote:
> On Mon, Dec 05, 2011 at 07:23:40PM +0200, Felipe Contreras wrote:
>> From: Felipe Contreras <felipe.contreras@gmail.com>
>>
>> This reverts commit 10299e2e4e3ed3b16503d4e04edd48b33083f4e2.
>>
>> This seems to break USB networking stuff.
>>
>> Cc: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
>> Cc: Heikki Krogerus <heikki.krogerus@nokia.com>
>> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> ---
>>  arch/arm/mach-omap2/board-rx51-peripherals.c |   27 +------------------------
>>  1 files changed, 2 insertions(+), 25 deletions(-)
>
> <snip>
>
>> -static void __init rx51_charger_init(void)
>> -{
>> -     WARN_ON(gpio_request_one(RX51_USB_TRANSCEIVER_RST_GPIO,
>> -             GPIOF_OUT_INIT_LOW, "isp1704_reset"));
>
> How about simply GPIOF_OUT_INIT_HIGH here. Is that not enough to fix
> your problem? Revering the whole thing does not make any sense to me.

Yes, that fixes it :)

-- 
Felipe Contreras
