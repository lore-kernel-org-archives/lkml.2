Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab2BXNQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:16:30 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:43944 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755272Ab2BXNQL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:16:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.60.1.230 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
MIME-Version: 1.0
In-Reply-To: <5240114.8TkZqEVLeL@fodrek.kar.elf.stuba.sk>
References: <5240114.8TkZqEVLeL@fodrek.kar.elf.stuba.sk>
Date: Fri, 24 Feb 2012 15:16:10 +0200
X-Google-Sender-Auth: TJ0bgPbtisMYcvz9H7qNCeOt7VQ
Message-ID: <CAOJsxLGcxggrN42urdBxQNPBUSjXtFpT=FfczKiYvQW2+AFJOQ@mail.gmail.com>
Subject: Re: Resening: KGDB over Ethternet howto patch
From: Pekka Enberg <penberg@kernel.org>
To: fodrek@kasr.elf.stuba.sk
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 3:01 PM,  <fodrek@kasr.elf.stuba.sk> wrote:
> I would like to ask you how to debug linux kernel over etherent.
> We are designing aplication usaig RTAI (Hard realtime extension using kenrel
> patch too) and we have been found some problems in our Linux kernel module.
>
> This module serves a hard realime RTAI application and we are to debug it
> using Ethernet insatead of RS232/RS485 or other UART port as is  possible
> out of box. We are familiar to use gdb as weel as for remote debuging of the
> usewr space application but not debuging kernel.
>
> Excuse me if I am sending messige to the wrong mailing list, please?

There's some traces of "kgdboe" in mainline code but I don't think
that feature was ever merged.

                                 Pekka
