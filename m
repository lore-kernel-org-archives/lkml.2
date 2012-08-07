Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2HGI7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:59:24 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37747 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2HGI7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:59:23 -0400
MIME-Version: 1.0
In-Reply-To: <CANYdXnr4B_EtvPcYXvqqgttK3w5y-+ABD-bdYEwAzbJRNnxqrg@mail.gmail.com>
References: <CANYdXnqCY+Uc=ROvQHv4kRe-g2zoEjfpzV0P83exfXYm-qCBaA@mail.gmail.com>
	<CAFLxGvy_X0r4njVMdUe1jnGciZYmcQr6d_ZpqOkZzQGc72yW2g@mail.gmail.com>
	<CANYdXnr4B_EtvPcYXvqqgttK3w5y-+ABD-bdYEwAzbJRNnxqrg@mail.gmail.com>
Date: Tue, 7 Aug 2012 10:59:22 +0200
Message-ID: <CAFLxGvy5zO0iatdwdvJte3Q7Lt+jzZ6jxdAwxUe74wFvJY2mug@mail.gmail.com>
Subject: Re: A question on serial driver
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 10:49 AM, Shashidhar Hiremath
<shashidharh@vayavyalabs.com> wrote:
> Hi Richard,
>    I am new to serial framework. Can you please elaborate on what you
> mean by implementing a hangup ?

struct tty_operations' hangup()

-- 
Thanks,
//richard
