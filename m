Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257Ab0JGJ4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 05:56:25 -0400
Received: from asmtpout024.mac.com ([17.148.16.99]:58679 "EHLO
	asmtpout024.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab0JGJ4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 05:56:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-07_06:2010-10-07,2010-10-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010070024
From: Elvis Dowson <elvis.dowson@mac.com>
Subject: Debugging Linux OMAP kernel with kgdb and Eclipse
Date: Thu, 07 Oct 2010 13:55:24 +0400
Message-id: <1A4750AE-4E56-4376-A187-0742A81AAA53@mac.com>
To: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
       I'm trying to setup a kernel debugging environment for the Gumstix Overo Earth (TI OMAP 3503) + Palo43 using Eclipse. 

I have enabled kgdb in the kernel (linux-omap-2.6.32 based android kernel).

My bootargs were

# setenv console ttyS2,115200n8
# setenv mmcargs 'setenv bootargs console=${console} vram=12M omapfb.vram=0:4M omapfb.mode=dvi:${dvimode} omapdss.def_disp=${defaultdisplay} root=/dev/mmcblk0p2 rw rootfstype=ext3 rootwait init=/init kgdboc=${console} kgdbwait'

The kernel boots and waits correctly for input as follows:

console [ttyS2] enabled
kgdb: Registered I/O driver kgdboc.
kgdb: Waiting for connection from remote gdb...

I have also configure Eclipse IDE, and built the kernel, and when I run it in debug mode, it launches the kernel and the whole android OS boots correctly, and Eclipse IDE shows a number of threads running, but I can seem to see any source code highlighted, even through I set a breakpoint in board-overo.c (my board file) for the init board routine. It should have stopped and paused execution at the breakpoint. 

Question 01: When building from Eclipse IDE, it builds uImage, but for the debug settings, I selected vmlinux that was generated in the root folder. I ran uImage on the target board, but for the executable for the debug session I used vmimage. Is that correct?

When I launch Eclipse debugger, I can see a number of threads running, it doesn't display any source code, I can't pause any threads, and the breakpoints don't appear to be working. 

What should I do ?

Best regards,

Elvis Dowson
