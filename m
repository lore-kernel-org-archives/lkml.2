Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab1JHNCm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 09:02:42 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42400 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab1JHNCj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 09:02:39 -0400
MIME-Version: 1.0
In-Reply-To: <14032344.tng7XWeaFg@wuerfel>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
 <201110071156.38283.arnd@arndb.de> <CAMPhdO97bJZ1FRHUq_VHQ8oHyY7U4ay-jv5Ft+gunRwtBvz8qw@mail.gmail.com>
 <14032344.tng7XWeaFg@wuerfel>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 8 Oct 2011 21:02:19 +0800
Message-ID: <CAMPhdO8D+faQksn79NBWMb_mdsAw0tSatvEL-zhN4jNjKm+trg@mail.gmail.com>
Subject: Re: [PATCH 08/26] ARM: pxa: move z2 to generic cpu_suspend
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 8, 2011 at 9:00 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 08 October 2011 20:37:53 Eric Miao wrote:
>> >>
>> >>  #ifdef CONFIG_PM
>> >> +extern void pxa27x_cpu_pm_enter(suspend_state_t state);
>> >> +
>> >>  static void z2_power_off(void)
>> >>  {
>> >>         /* We're using deep sleep as poweroff, so clear PSPR to ensure that
>> >
>> > You really shouldn't have an extern declaration in a .c file. Otherwise
>> > looks good to me.
>>
>> How about this one?
>
> Yes, looks good as far as I can tell (I still don't quite understand how the
> cpu power management all fits together, but I don't see anything wrong with
> it either.
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks.
