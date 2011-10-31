Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1JaFaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 01:30:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39701 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1JaFaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 01:30:16 -0400
MIME-Version: 1.0
Date: Mon, 31 Oct 2011 11:00:14 +0530
Message-ID: <CAJw04pD24W_nGSLheWunCa_o7QqBmRf_TSAD44EkzazigRe_nQ@mail.gmail.com>
Subject: powerpc 476, Little-endian, pte fault
From: Santosh Kumar <santoshkumar.a@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KERNEL: linux 2.6.39.4
POWERPC: 476, little endian.

I am trying to get linux 2.6.39.4 up on PPC 476 i have done done
Big-endian to little endian Changes in:
1) bitops header file.
2) while reading the device tree.
3) the PTE read/computed in head_32.S
4) added E bit in the TLB entries.

with all the above changes the kernel_init is done but and inited is mounted.

But while spawning init process the kernel continuously hits pte
faults at address 0x100000fc and never comes out. Please let me know
where i should be looking into.

-
Thanks
Santosh Kumar .A

Vision without Action is a daydream... Action without Vision is a nightmare...
