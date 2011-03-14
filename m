Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1CNKtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:49:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43817 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab1CNKtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=tBGVyAPIzAdLhiMMua+YNr96LlRFJeuCbfxD8ZscWgWkYdTG6llMXJgU+OnRlYXhpj
         PxSSHYGVnWiVBzGehOkM3JfLPYy5wN8Ech0NDPlKHQV9jyYr3xtIlVnds6cAz1EzQU80
         iIC1ligB3vH7LNT4RR3gmpySvYMNfd1vD/khk=
MIME-Version: 1.0
From: Amirali Shambayati <amirali.shambayati@gmail.com>
Date: Mon, 14 Mar 2011 14:18:50 +0330
Message-ID: <AANLkTikLQ_nd3XAeR+nj2fRF8hPLJLn59OO=j6noVsZH@mail.gmail.com>
Subject: Switch between IO schedulers at runtime
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I'm using Qemu + GDB to debug my new IO scheduler code. I need to be
able to switch between IO schedulers at runtime. As much as I know and
I've tested it in my system, I should echo 'IO-sched name'>
/sys/block/sda/queue/scheduler but the linux image I use(linux-0.2.img
Small Linux disk image containing a 2.6.20 Linux kernel, X11 and
various utilities to test QEMU ) doesn't have "sys folder". Anybody
knows another way to switch IO schedulers runtime?

Any help is appreciated.

Regards,

-- 
Amirali Shambayati
Bachelor Student
Computer Engineering Department
Sharif University of Technology
Tehran, Iran
