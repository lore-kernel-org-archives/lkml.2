Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0K2BjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 20:39:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54400 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab0K2BjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 20:39:20 -0500
MIME-Version: 1.0
Reply-To: paul.clements@us.sios.com
Date: Sun, 28 Nov 2010 20:39:19 -0500
Message-ID: <AANLkTi=sgeLzBpfDHquf7zMpdgSq_0qy0WF4YEMMNVqN@mail.gmail.com>
Subject: Re: NBD and 2.6 kernel MIPS problem
From: Paul Clements <paul.clements@steeleye.com>
To: Hans Beckerus <hans.beckerus@telia.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi!
>
>> Hi, I recently compiled the NBD kernel module for a 2.6 ucLibc
>> kernel and are experiencing
>> some crash problems. Are there any known issues with the 2.6 range
>> of kernels together with NBD?
>
> Nothing known to me, but I no longer maintain nbd. I suggest you ask
> lkml and Paul...
>
>									Pavel
>
>> The nbd-server and nbd-client seems ok though and handshaking works.
>> The platform is MIPS based.
>>
>> I also get these syslog entries when doing insmod:
>>
>> nbd: no version for "struct_module" found: kernel tainted.
>> nbd: registered device at major 43

The struct_module warning means you compiled nbd and the kernel with
different config options. Can you try reconciling that and see if
things work better?

--
Paul

>> The major device information I understand but not the first one.
>>
>> Best regards,
>> Hans
