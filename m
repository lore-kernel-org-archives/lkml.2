Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab0FAIhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:37:18 -0400
Received: from smtp7.myhsphere.biz ([204.10.105.69]:40003 "EHLO
	mail9.myhsphere.biz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754526Ab0FAIhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:37:15 -0400
X-Originating-IP: 61.11.90.129
Subject: PXA300-DDRAM base vaue
From: balakrishnan <balakrishnan@e-consystems.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 01 Jun 2010 14:07:03 +0530
Message-Id: <1275381423.7001.42.camel@balakrishnan-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am working on pxa300 based development board and using Linux 2.6.34.
This Linux kernel already has support for following boards
1. zylonite_pxa300
2. cm-x300 
3. colibri-pxa300
4. littleton

My doubt is that pxa300 based boards are using "0xa0000000"  as DDRAM
base and PHYS_OFFSET is also defined in
"arch/arm/mach-pxa/include/mach/memory.h" as 0xa0000000.
But in our board  DDR is mapped in 0x80000000. Does it make any
problem?. Because after mmu is turned ON, my board is hanging. 

"zreladdr-y   := 0x80008000" is defined in
"arch/arm/mach-pxa/Makefile.boot" file .
my machine_desc is as follows 
.phys_io        = 0x40000000, 
.io_pg_offst    = (io_p2v(0x40000000) >> 18) & 0xfffc,  
.boot_params    = 0x80000100,  

With Thanks
J.Balakrishnan

