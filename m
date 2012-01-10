Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab2AJKLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:11:32 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56911 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab2AJKLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:11:30 -0500
MIME-Version: 1.0
In-Reply-To: <20120109002946.GJ13679@sortiz-mobl>
References: <1325661266-7982-1-git-send-email-haojian.zhuang@marvell.com>
	<1325661266-7982-2-git-send-email-haojian.zhuang@marvell.com>
	<20120109002946.GJ13679@sortiz-mobl>
Date: Tue, 10 Jan 2012 18:11:29 +0800
Message-ID: <CAN1soZw1kVif-SeH_9zEDjUGVCYGFRV+m3YUgu4saDMga5DFWQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] misc: max8925_onkey: add function to work as wakeup source
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, a.zummo@towertech.it,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        Kevin Liu <kliu5@marvell.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 8:29 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Haojian,
>
> On Wed, Jan 04, 2012 at 03:14:25PM +0800, Haojian Zhuang wrote:
>> From: Kevin Liu <kliu5@marvell.com>
>
> I got this build error:
>
>  CC      drivers/input/misc/max8925_onkey.o
> drivers/input/misc/max8925_onkey.c: In function ‘max8925_onkey_suspend’:
> drivers/input/misc/max8925_onkey.c:169:30: error: ‘onkey_irq’ undeclared
> (first use in this function)
> drivers/input/misc/max8925_onkey.c:169:30: note: each undeclared identifier is
> reported only once for each function it appears in
> drivers/input/misc/max8925_onkey.c: In function ‘max8925_onkey_resume’:
> drivers/input/misc/max8925_onkey.c:181:32: error: ‘onkey_irq’ undeclared
> (first use in this function)
> make[3]: *** [drivers/input/misc/max8925_onkey.o] Error 1
> make[2]: *** [drivers/input/misc] Error 2
> make[1]: *** [drivers/input] Error 2
>
> So I put this one aside.
>
> Cheers,
> Samuel.
>

Hi Samuel,

I'm sorry on this patch. I'll send a new one to replace it.

Best Regards
Haojian
