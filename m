Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab1DZM2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:28:32 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:18627 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab1DZM20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:28:26 -0400
Subject: Re: [PATCH 1/6] arch: add #define for each of optimized find bitops
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
In-Reply-To: <1303638677-11211-2-git-send-email-akinobu.mita@gmail.com>
References: <1303638677-11211-1-git-send-email-akinobu.mita@gmail.com>
	 <1303638677-11211-2-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Tue, 26 Apr 2011 14:23:20 +0200
Message-ID: <1303820600.3125.13.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Apr 2011 12:26:57.0618 (UTC) FILETIME=[3C17CB20:01CC040D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-24 at 18:51 +0900, Akinobu Mita wrote:
> The style that we normally use in asm-generic is to test the macro itself
> for existence, so in asm-generic, do:
> 
> 	#ifndef find_next_zero_bit_le
> 	extern unsigned long find_next_zero_bit_le(const void *addr,
> 		unsigned long size, unsigned long offset);
> 	#endif
> 
> and in the architectures, write
> 
> 	static inline unsigned long find_next_zero_bit_le(const void *addr,
> 		unsigned long size, unsigned long offset)
> 	#define find_next_zero_bit_le find_next_zero_bit_le
> 
> This adds the #define for each of the optimized find bitops in the
> architectures.
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: linux390@de.ibm.com
> Cc: linux-s390@vger.kernel.org
> Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: linux-m68k@lists.linux-m68k.org
> Cc: Greg Ungerer <gerg@uclinux.org>

For the arch/avr32/include/asm/bitops.h changes.

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

-- 
Hans-Christian Egtvedt

