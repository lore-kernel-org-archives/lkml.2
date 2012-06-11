Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab2FKLe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:34:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57250 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab2FKLe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:34:28 -0400
MIME-Version: 1.0
Date: Mon, 11 Jun 2012 17:04:26 +0530
Message-ID: <CAJvAG3784zaQQ4yxZQnT+LqusaQdo1imEDZWfZ3kg+fEXbz0oQ@mail.gmail.com>
Subject: 64 bit address to a pcie card
From: sumit chaudhary <chaudhary.sumit21@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a 64 bit PCIe card that is connected to 64 bit PC running
ubuntu (Linux ubuntu 3.0.0-12-generic #20-Ubuntu SMP Fri Oct 7
14:56:25 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux). Linux enumerate
this PCIe card
and assign 64 bit addresses to 64 bit BARS.

Problem is that higher 4 bytes of these addresses are zero, even if
they are 64 bit address
they lies in 32 bit range.

Is it somehow possible to assign real 64 bit addresses ?

This is lspci output on my ubuntu PC.

Region 0: Memory at fddff000 (64-bit, non-prefetchable) [size=4K]
Region 2: Memory at fd000000 (64-bit, prefetchable) [size=8M]
Region 4: Memory at fc800000 (64-bit, prefetchable) [size=8M]

Please personally CC'ed the answers/comment.

Regards,
sumit.
