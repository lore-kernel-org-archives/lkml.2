Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191Ab0E0AHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 20:07:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38181 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab0E0AHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 20:07:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ovZR6I0SOQW7KjqWcbb5NN6QXjXRbIYkekvi2p7FWtJ1paeXXRfqsVZ8hkbfxAHktZ
         2jpuGTcWbghMTBIaoMuygPmsbL/j6/IHxweq0mtWA0Wj6Vs2NFYaPOYDo7Pw3IFKdJwD
         IHT62Tyugfqbu1S1isGmDaRZXzb9GsscXNSgo=
MIME-Version: 1.0
Date: Thu, 27 May 2010 05:37:36 +0530
Message-ID: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com>
Subject: config automatically switches from 32-bit to 64-bit for x86
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am trying to build 32 bit kernel image on 64-bit machine but after
'make menuconfig' it automatically switches 32-bit to 64-bit.

Is this a BUG or did intentionally.

How can I fix this issue.


.config (before)
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.34
# Wed May 26 03:40:31 2010
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y

.config (after 'make menuconfig' on 64-bit box)
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.34
# Wed May 26 23:49:18 2010
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y

Thanks,
--
Jaswinder Singh.
