Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab0JEWq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 18:46:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36400 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab0JEWq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 18:46:26 -0400
Message-ID: <4CABAAB4.3090707@zytor.com>
Date: Tue, 05 Oct 2010 15:46:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Section mismatches in memblock
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o.i386-allconfig/make.log:WARNING: mm/built-in.o(.text+0x48b6f): Section
mismatch in reference from the function memblock_is_memory() to the
variable .init.data:memblock
o.i386-allconfig/make.log:The function memblock_is_memory() references
o.i386-allconfig/make.log:This is often because memblock_is_memory lacks
a __initdata
o.i386-allconfig/make.log:WARNING: mm/built-in.o(.text+0x48bb0): Section
mismatch in reference from the function memblock_is_region_memory() to
the variable .init.data:memblock
o.i386-allconfig/make.log:The function memblock_is_region_memory()
references
o.i386-allconfig/make.log:This is often because
memblock_is_region_memory lacks a __initdata
o.i386-allconfig/make.log:WARNING: mm/built-in.o(.text+0x48bd5): Section
mismatch in reference from the function memblock_is_region_memory() to
the variable .init.data:memblock
o.i386-allconfig/make.log:The function memblock_is_region_memory()
references
o.i386-allconfig/make.log:This is often because
memblock_is_region_memory lacks a __initdata

Happens with both i386 and x86-64.

	-hpa
