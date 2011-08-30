Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1H3GHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 02:07:37 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38195 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab1H3GHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 02:07:36 -0400
MIME-Version: 1.0
From: Vishnupradeep <intermedia.vishnu@gmail.com>
Date: Tue, 30 Aug 2011 11:37:15 +0530
Message-ID: <CACk0-C9jZatg+v=7DPJtkp3G1k_eiZbwSPDAgqabMyedmKd9YA@mail.gmail.com>
Subject: linux-3.0.4 compile error on file arch/x86/include/asm/unistd_64.h
To: linux-kernel@vger.kernel.org
Cc: Vishnu Pradeep <intermedia.vishnu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC      net/ipv4/ip_forward.o
CC      net/ipv4/ip_options.o
CC      net/ipv4/ip_output.o
CC      net/ipv4/ip_sockglue.o
In file included from
/media/Portable/linux-kernel/linux-3.0.4/arch/x86/include/asm/unistd.h:5:0,
                 from include/linux/unistd.h:7,
                 from
/media/Portable/linux-kernel/linux-3.0.4/arch/x86/include/asm/seccomp_64.h:4,
                 from
/media/Portable/linux-kernel/linux-3.0.4/arch/x86/include/asm/seccomp.h:4,
                 from include/linux/seccomp.h:8,
                 from include/linux/sched.h:80,
                 from
/media/Portable/linux-kernel/linux-3.0.4/arch/x86/include/asm/compat.h:8,
                 from include/linux/compat.h:18,
                 from include/linux/ethtool.h:17,
                 from include/linux/netdevice.h:48,
                 from include/linux/inetdevice.h:8,
                 from net/ipv4/ip_sockglue.c:24:
/media/Portable/linux-kernel/linux-3.0.4/arch/x86/include/asm/unistd_64.h:668:2:
error: invalid preprocessing directive #Define
make[2]: *** [net/ipv4/ip_sockglue.o] Error 1
make[1]: ***
make: *** [net] Error 2
[vishnu@localhost linux-3.0.4]$
