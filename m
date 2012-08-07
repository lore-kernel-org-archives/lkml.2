Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2HGIgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:36:54 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36952 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2HGIgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:36:52 -0400
MIME-Version: 1.0
In-Reply-To: <CANYdXnqCY+Uc=ROvQHv4kRe-g2zoEjfpzV0P83exfXYm-qCBaA@mail.gmail.com>
References: <CANYdXnqCY+Uc=ROvQHv4kRe-g2zoEjfpzV0P83exfXYm-qCBaA@mail.gmail.com>
Date: Tue, 7 Aug 2012 10:36:51 +0200
Message-ID: <CAFLxGvy_X0r4njVMdUe1jnGciZYmcQr6d_ZpqOkZzQGc72yW2g@mail.gmail.com>
Subject: Re: A question on serial driver
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 10:22 AM, Shashidhar Hiremath
<shashidharh@vayavyalabs.com> wrote:
> Hi,
>  I have written a console driver where I also do the serial driver
> registration and handling. The driver seems to work fine till the
> login point(reads and writes). The driver for some reason does not
> print the content  I type on console after login prompt. Any reason
> why this might be happening ?

login and getty do a lot of TTY black magic, maybe you forgot to implement
something like hangup()...
Use strace to find out what the login programs are doing.

-- 
Thanks,
//richard
