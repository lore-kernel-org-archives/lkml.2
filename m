Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab1BQCDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 21:03:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54609
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751520Ab1BQCDL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:03:11 -0500
Date: Wed, 16 Feb 2011 18:03:47 -0800 (PST)
Message-Id: <20110216.180347.71107177.davem@davemloft.net>
To: yong.zhang0@gmail.com
Cc: daniel.lezcano@free.fr, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: WARNING: at kernel/lockdep.c:2323
 trace_hardirqs_on_caller+0xb9/0x16c()
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimvue3JbYZUMrt0KppE1f_MNSsyyb+Upbputs=5@mail.gmail.com>
References: <4D5A90D0.9040403@free.fr>
	<AANLkTimvue3JbYZUMrt0KppE1f_MNSsyyb+Upbputs=5@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang0@gmail.com>
Date: Thu, 17 Feb 2011 09:37:30 +0800

> On Tue, Feb 15, 2011 at 10:42 PM, Daniel Lezcano <daniel.lezcano@free.fr> wrote:
>> Hi All,
>>
>> I am running a 2.6.38-rc4-next-20110215+ kernel on qemu x86_64 and the
>> following traces appear in the console:
>>
>> Feb 15 15:00:24 lucid kernel: ------------[ cut here ]------------
>> Feb 15 15:00:24 lucid kernel: WARNING: at kernel/lockdep.c:2323
>> trace_hardirqs_on_caller+0xb9/0x16c()
>> Feb 15 15:00:24 lucid kernel: Hardware name: Bochs
>> Feb 15 15:00:24 lucid kernel: Pid: 1477, comm: mountall Not tainted
>> 2.6.38-rc4-next-20110215+ #74
>> Feb 15 15:00:24 lucid kernel: Call Trace:
>> Feb 15 15:00:24 lucid kernel: <IRQ>  [<ffffffff8102b8a5>] ?
>> warn_slowpath_common+0x7b/0x93
>> Feb 15 15:00:24 lucid kernel: [<ffffffff8146c097>] ?
>> _raw_spin_unlock_irq+0x2b/0x30
>> Feb 15 15:00:24 lucid kernel: [<ffffffff8102b8d2>] ?
>> warn_slowpath_null+0x15/0x17
>> Feb 15 15:00:24 lucid kernel: [<ffffffff8104f796>] ?
>> trace_hardirqs_on_caller+0xb9/0x16c
>> Feb 15 15:00:24 lucid kernel: [<ffffffff8104f856>] ?
>> trace_hardirqs_on+0xd/0xf
>> Feb 15 15:00:24 lucid kernel: [<ffffffff8146c097>] ?
>> _raw_spin_unlock_irq+0x2b/0x30
>> Feb 15 15:00:24 lucid kernel: [<ffffffff812e167e>] ?
>> do_ide_request+0x32/0x590
> 
> Seems related to IDE SUBSYSTEM

Which hasn't had any changes in the past release.
