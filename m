Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0DMN1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 09:27:39 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41021 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab0DMN1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:27:38 -0400
Message-ID: <4BC4713F.6030702@monstr.eu>
Date: Tue, 13 Apr 2010 15:27:27 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Michael Schnell <mschnell@lumino.de>
CC: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>,
       John Linn <John.Linn@xilinx.com>,
       Stefan Asserhall <stefan.asserhall@xilinx.com>,
       Goran Bilski <goran@xilinx.com>,
       "Steven J. Magnani" <steve@digidescorp.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
       Grant Likely <grant.likely@secretlab.ca>, sam@ravnborg.org,
       stephenn@xilinx.com, Karen Whelan <karen.whelan@petalogix.com>,
       Wendy Liang <wendy.liang@petalogix.com>
Subject: Re: Microblaze - The fist year
References: <4BC461AD.6090504@monstr.eu> <4BC46DC6.5050309@lumino.de>
In-Reply-To: <4BC46DC6.5050309@lumino.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Schnell wrote:
> Does Microblaze MMU Linux support Futex ?

yes, futex is there. You can check it in
arch/microblaze/include/asm/futex.h

> Does Microblaze MMU Linux support SMP ?

It is possible to connect several MicroBlazes but the problem is missing 
cache coherency modul. I hope that Xilinx will release any version which 
will support it.
We haven't done any significant work to support it but it is expected 
solution which will happen.

Thanks for input,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
