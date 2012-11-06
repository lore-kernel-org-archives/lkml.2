Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644Ab2KFCbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 21:31:07 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39138 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609Ab2KFCbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 21:31:04 -0500
MIME-Version: 1.0
From: WANG Siyuan <wangsiyuanbuaa@gmail.com>
Date: Tue, 6 Nov 2012 10:30:44 +0800
Message-ID: <CAKhuMPm1qG-t93+TOi1xHDDnV2Gm-DqR4JQEZDuGZPyqzWejkw@mail.gmail.com>
Subject: firmware issue: do_IRQ: X 55 No irq handler for vector (irq -1)
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Firstly, this is a coreboot issue rather than kernel issue. I don't
know how to deal with it so come here to ask for help.

I am debugging coreboot which is an open source bios on a mainboard now.
the mainboard is tyan s8226, which has two CPUs and each CPU has 8 cores.
the details of s8226 could be googled. I can't insert link.

I encountered a problem these days. The dmesg has such error:

do_IRQ: X 55 No irq handler for vector (irq -1)
where X is from 1 to 10

this message is printed by do_IRQ() in arch/x86/kernel/irq.c

this is my coreboot issue, because other bios doesn't have this dmesg error.
it seems that this error has no effect to the system. Linux works well
now. But I want to resolve this issue.

I am not familiar with linux kernel, so I don't know how to locate the problem.
would anybody give me some suggestion?
thank you!
I can't send the whole dmesg, because it is rejected. I don't know why.

--
WANG Siyuan
