Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1HRJGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 05:06:12 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:36916 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab1HRJGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 05:06:10 -0400
MIME-Version: 1.0
In-Reply-To: <4E43F44A.1000509@scram.de>
References: <1312793379-6020-1-git-send-email-jochen@scram.de> <4E43F44A.1000509@scram.de>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Thu, 18 Aug 2011 17:05:49 +0800
X-Google-Sender-Auth: v-Hh8Z50sme0ddhfQSNiFwRBdNE
Message-ID: <CAK5ve-J7ARjDDm2OzrBiBBd9VrMjdDdihiRcPFwK4xm+_gwMrg@mail.gmail.com>
Subject: Re: [PATCH 3.2 0/4] ARM: simpad: Add support for GPIO attached hardware
To: Jochen Friedrich <jochen@scram.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: kristoffer.ericson@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 11:24 PM, Jochen Friedrich <jochen@scram.de> wrote:
> On 08.08.2011 10:49, Jochen Friedrich wrote:
>
>> This series enables GPIO API on UCB1x00 and implements the GPIO
>> API on the CS3 latch. The third patch finally registers platform
>> devices for the GPIO attached LED, buttons and I2C bus.
>>
>> ARM: simpad: Add ucb1x00 GPIO definitions and register GPIO
>> ARM: simpad: Cleanup CS3 accessors and add GPIO API
>> ARM: simpad: add GPIO based device definitions
>> ARM: simpad: replace ARM specific LED code
>
> ping.
>
> Did someone have time to look at this yet?
>
Russell,

Is there any comment, or Jochen can just submit them into patch system

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Ubuntu Kernel Team
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
