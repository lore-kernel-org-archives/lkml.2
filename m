Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab2AQGXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 01:23:33 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65331 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2AQGXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 01:23:32 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <87aa5nhohv.fsf@rustcorp.com.au>
References: <1326673943-26105-1-git-send-email-olof@lixom.net>
	<87aa5nhohv.fsf@rustcorp.com.au>
Date: Mon, 16 Jan 2012 22:23:32 -0800
Message-ID: <CAOesGMgTqKxKMQ3SW4kJVKyNdHGPS0pJTXtmHFzwgM3RJYfNnA@mail.gmail.com>
Subject: Re: [PATCH] modules: fix build error with !CONFIG_MODULE_UNLOAD
From: Olof Johansson <olof@lixom.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 3:32 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Sun, 15 Jan 2012 16:32:23 -0800, Olof Johansson <olof@lixom.net> wrote:
>> Looks like the "module_flags_taint" helper was added under an #ifdef
>> CONFIG_MODULE_UNLOAD block, move it out of it.
>>
>> Fixes:
>>
>> kernel/module.c: In function 'show_taint':
>> kernel/module.c:1024:2: error: implicit declaration of function 'module_flags_taint'
>>
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>
> Applied.


It looks like Linus already took an equivalent patch (shortly after I
had sent mine). You can drop it to avoid conflicts.


Thanks!

-Olof
