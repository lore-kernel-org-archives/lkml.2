Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab0JFVBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 17:01:21 -0400
Received: from asmtpout023.mac.com ([17.148.16.98]:62830 "EHLO
	asmtpout023.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab0JFVBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 17:01:20 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010060138
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-06_11:2010-10-06,2010-10-06,1970-01-01 signatures=0
Subject: Re: Kernel config option missing: 'Compile the kernel with frame
 pointers'
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <55150.64.39.142.105.1286398399.squirrel@xenotime.net>
Date: Thu, 07 Oct 2010 01:00:53 +0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <22641647-5901-4C65-99D0-F9BF2064AD91@mac.com>
References: <B2C884FB-3933-4363-85C6-4F1206275B4C@mac.com>
 <55150.64.39.142.105.1286398399.squirrel@xenotime.net>
To: Randy Dunlap <rdunlap@xenotime.net>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Oct 7, 2010, at 12:53 AM, Randy Dunlap wrote:
> 
> It sounds like you don't have DEBUG_KERNEL symbol set.
> You can't see the FRAME_POINTER kconfig symbol unless
> DEBUG_KERNEL is set/enabled and you are on a qualifying
> architecture:
> 
> config FRAME_POINTER
>        bool "Compile the kernel with frame pointers"
>        depends on DEBUG_KERNEL && \
>                (CRIS || M68K || M68KNOMMU || FRV || UML || \
>                 AVR32 || SUPERH || BLACKFIN || MN10300) || \
>                ARCH_WANT_FRAME_POINTERS
>        default y if (DEBUG_INFO && UML) || ARCH_WANT_FRAME_POINTERS
> 
> 
> The prompt for DEBUG_KERNEL is "Kernel debugging".
> It is in the "Kernel hacking" menu.

I have CONFIG_DEBUG_KERNEL=y set. I'm compiling for the ARM architecture (TI OMAP 3503). So I guess it doesn't apply for ARM?

I want to debug the kernel using Eclipse IDE and kgdb.

Best regards,

Elvis
