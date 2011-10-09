Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab1JIH2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 03:28:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45326 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1JIH2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 03:28:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAN1soZzbtqxfNLS_JVhn1irXRVThL=yt_VWfmdkoUL2ShFDEGQ@mail.gmail.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
 <CAMPhdO_L-g4vSj3fC-1ckqnHGAPhWOy6Hm4VL5iUbZbbdjRkNQ@mail.gmail.com>
 <CAN1soZy3_9Trycti8SCbnO75N6NE31tFqrKMpZtiJPgwNc2cbg@mail.gmail.com>
 <1499585.ED4ktnBDpX@wuerfel> <CAN1soZyDu43EN3W5YBttdzx7qx=MLKAR1OsJC3hUdqWWxhQaew@mail.gmail.com>
 <CAMPhdO8_cZU8FEGsK0m_XrhbR33TiZFFaNrXddKT1YrHREt-TQ@mail.gmail.com> <CAN1soZzbtqxfNLS_JVhn1irXRVThL=yt_VWfmdkoUL2ShFDEGQ@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sun, 9 Oct 2011 15:28:18 +0800
Message-ID: <CAMPhdO-b2hiXUNSKLqio4uHOEby=H82ckC0oahzRToatXmzw_g@mail.gmail.com>
Subject: Re: [PATCH 17/26] ARM: pxa: pxa95x is incompatible with earlier pxa
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Jason Chagas <jason.chagas@marvell.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> They are actually not mutually exclusive - it's a trick we use to select
>> MACH_TAVOREVB3 by default but this option also disappears once SAARB
>> is selected.
>>
> OK. Could I know why saarb should be deselected while tavorevb3 is selected?

Haojian, it's not being deselected, it's just when user selects SAARB,
this config PXA_V7_MACH_AUTO becomes invalid (which means at
least one PXA_V7_MACH is selected), and then you could select
TAVOREVB3 as well.

Just go ahead and apply the patch, make menuconfig and see how
the trick works :-)
