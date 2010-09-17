Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0IQFsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 01:48:53 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58245 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0IQFsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 01:48:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=n0tfmnQZCnyDqwqlzc8jS5+Te5nWYW7+/eIe447IDDS8/YU6K48kKaMcZmhz0BqpHk
         vi9Thmz9OOQUA7/Z0a7kOUsHuZvhRY6FKIjFen+ZIasKur0KUQR/D/7MbuXBauUBtwmn
         rbOGdd3GV7ApH2JRfFSK+A+6UWh0/gtMo7IQU=
MIME-Version: 1.0
In-Reply-To: <4C861A09.5020203@ladisch.de>
References: <AANLkTiktFQWvz-TzewKYEd1wtEbe3cVFjFca4dFtUTCV@mail.gmail.com>
	<4C85F0E3.2050908@ladisch.de>
	<AANLkTi=-=88y=6kvV-WC3b5Pw7cf_ZoPaxhUnYugQK81@mail.gmail.com>
	<4C860043.9000501@ladisch.de>
	<AANLkTimbDOb-iJgRmpEb29GVfP-K0_6TtvPSF7eK-2ts@mail.gmail.com>
	<4C861A09.5020203@ladisch.de>
Date: Fri, 17 Sep 2010 11:18:51 +0530
Message-ID: <AANLkTinrtwMnvutZV+NSOyu9O8iXdRvBnUF7EBs-M4cM@mail.gmail.com>
Subject: Re: Hungry for hardware timers
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry for delay.

On Tue, Sep 7, 2010 at 4:25 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Jaswinder Singh Rajput wrote:
>
>> What will be IRQ # for T2.
>
> Just check while hpet_example is running ...
>

$ cat /proc/interrupts | grep hpet
 20:         24          0   IO-APIC-fasteoi   hpet2

I am planning to use hpet2 from modules. But currently it seems
hpet_readl() and hpet_writel() are not accessible from outside the
kernel. Is there any plans to export them.

Thanks,
--
Jaswinder Singh.
