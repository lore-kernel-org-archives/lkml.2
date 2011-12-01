Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1LAJ5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:57:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37037 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab1LAJ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:57:31 -0500
MIME-Version: 1.0
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Thu, 1 Dec 2011 10:57:09 +0100
Message-ID: <CAL8zT=juU_PC92R4za31R8Lmur0PrFwog1m1fk+PEarW_0C6ng@mail.gmail.com>
Subject: Different behaviour when using "nosmp" parameter on SMP and UP
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linuxppc-dev <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a P2020 CPU (powerpc) and I compiled it with two different defconfigs.
The first one is a SMP, 2 cores, launched with the "nosmp" kernel
parameter, the other one is an UP kernel.

My driver behaviour is not the same whether launching one or the
other. It is hard to explain more precisely, as it deals only with
ioctl which only does ioread32/iowrite32 on a PCIe device.
But I can tell that it never works the same way when UP (not working
correctly), or SMP "nosmp" (working) or even SMP (not working).

AFAIK, the "nosmp" parameter should tell the kernel to act the same is
if it is an UP kernel, and it disables IO APIC, which is not an issue
in my case.

Can you think about anything that would explain it, or would help me
debugging it ?

Thanks in advance for your help.
Regards,
JM
