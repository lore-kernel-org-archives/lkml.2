Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0L1H1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 02:27:11 -0500
Received: from mailsmtp4.bora.net ([211.40.221.198]:38872 "HELO
	mailsmtp4.bora.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750960Ab0L1H1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 02:27:08 -0500
From: "Sung-Uk Park" <nothing@zpsys.com>
To: "'Sung-Uk Park'" <nothing@zpsys.com>, <linux-kernel@vger.kernel.org>
References: 
Subject: Kernel oops !!! Help !!!
Date: Tue, 28 Dec 2010 16:27:24 +0900
Message-ID: <34A653E1985643A197A7A15CF61572C8@sungukpark>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: 
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Thread-Index: AcumWi6dognkIRh/RXCv73WvgnEq3wABmXUw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there...
 
I got kernel oops please anybody help me~~~~
 
Dump message :
 
CPU 0 Unable to handle kernel paging request at virtual address 00000084,
epc == 8000cb68, ra == 80001624
Kernel unaligned instruction access[#1]:
Cpu 0
$ 0   : 00000000 1000ff00 b4b43427 18800010
$ 4   : c3645514 8000a210 00000000 801ce4a0
$ 8   : 1000ff00 86ff20e8 00000023 2aaf8000
$12   : 00000022 92190000 8053b5e4 00000010
$16   : 86ff20e8 dbfe7cce 80540000 0000001d
$20   : 00000000 0000006d 00030000 801d0000
$24   : 00000008 00000001                  
$28   : 86ff2000 86ff20c0 000005a8 80001624
Hi    : 00000095
Lo    : e9e7e000
epc   : 8000a210 do_ade+0x40/0x310     Not tainted
ra    : 80001624 _ret_from_irq+0x0/0x10
Status: 1000ff02    KERNEL EXL 
Cause : 18800010
BadVA : b4b4373b
PrId  : 0001906c
Modules linked in: rtdrv zpdrv rtk rtcore
Process B1He?èá&QBΩP±‘¥Ü #p€˛|? (pid: 411041808, threadinfo=86ff2000,
task=86ff20e8)
Stack : cb433090 a750b81e d66b2c4f 704a712a b6dae55a 5c67eb64 86ff21c0
dbfe7cce
        80001624 58ef86ef 7a8f6d31 ff1be7c0 b8bc6a6b b16d3d75 f8775180
e5c27d9f
        00000000 1000ff00 b4b43427 18800010 c3645514 8000a210 00000000
801ce4a0
        1000ff00 86ff21c0 00000023 2aaf8000 00000022 92190000 8053b5e4
00000010
        86ff21c0 dbfe7cce 80540000 0000001d 00000000 0000006d 00030000
801d0000
        ...
Call Trace:
[<8000a210>] do_ade+0x40/0x310
 

Code: 00000000  8f820000  8e0300a8 <8c440314> 3c028000  00621824  30840001
24a20004  1080009b 
Kernel panic - not syncing: Fatal exception in interrupt
 Machine Restart ...
..


 
I am using MIPS CPU with linux kernel 2.6.19.
What is the problem?
Need more informations?
 
 
Regards,
 
 
Sung-Uk.

