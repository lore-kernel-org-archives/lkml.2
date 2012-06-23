Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab2FWN6a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 09:58:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59369 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2FWN63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 09:58:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVyJq2BzQ6anviJrWcRqNAP1EU-ngCMA267utc2B2soVQ@mail.gmail.com>
References: <CAN_1RdvqJRig8vZW_gcvNVKYNo7ROmEKxAs7qu1N6XE4+Pspjg@mail.gmail.com>
	<20120623040633.GA16278@kroah.com>
	<CAN_1RdtfiWtuqV=vBkagZfmvstket499QdCK3zZrrS8xKTZwPA@mail.gmail.com>
	<20120623044105.GA32663@kroah.com>
	<CAN_1RduD=yh0vjVdb3RwQn9ivxcBEGgJ3aTXuGgj4=FEznYmXg@mail.gmail.com>
	<CAM_iQpVyJq2BzQ6anviJrWcRqNAP1EU-ngCMA267utc2B2soVQ@mail.gmail.com>
Date: Sat, 23 Jun 2012 21:58:27 +0800
Message-ID: <CAN_1RdujZ6ZFEecP26cKp0xvnSrXWOXgJnbcm6E3wCYPTSz4Dg@mail.gmail.com>
Subject: Re: [PATCH] Implement uhook(call kernel func from userspace) driver
From: Peiyong Feng <peiyong.feng.kernel@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/23 Cong Wang <xiyou.wangcong@gmail.com>:
> On Sat, Jun 23, 2012 at 2:01 PM, Peiyong Feng
> <peiyong.feng.kernel@gmail.com> wrote:
>>
>> I mean that although the main line kernel cannot accept this patch, and
>> uhook is very useful to play a rule as a debug tool.
>
> It depends, we already have kprobe, tracepoint, kgdb, kdump...

May be I am not make myself understood. The uhook is not like kgdb, kprobe or
some other debug tools. As I mentioned in previous mail that we can
run the kernel
ksymbal while kernel is running, not like the kgdb that need some
hardware driver support
(lots of problems occurred when I try kgdb),

uhook is more "soft", it just provide a way that can call kernel
routine or ksymbals Asynchronously.

Easy but efficent. I have used it to develop device drivers, very
nice, and not every platform or board support
kgdb.
>
>> Is there some where else
>> that can hold this tool, and let more people use the uhook?
>
> You have github, don't you?
