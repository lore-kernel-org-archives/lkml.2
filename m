Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab1JUQw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 12:52:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57810 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab1JUQwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 12:52:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tim Bird <tim.bird@am.sony.com>, Russell King <rmk@arm.linux.org.uk>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: Add static kernel function stack size analyzer, for ARM
Date: Wed, 19 Oct 2011 12:45:50 +0200
Message-ID: <1861853.vLiqXrnQg4@wuerfel>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <4E9E0C66.3020405@am.sony.com>
References: <4E9E0B71.9020708@am.sony.com> <4E9E0C66.3020405@am.sony.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:dFpCgYHOmGT6lO4XpcILvMGMBSi9oMSIKENp3SKWmeR
 V1i/mLgaN/SqcAVbQM1tvCXee16J6dc6IYv6+WgZybWB4UcVWd
 P6aXzcD3csDdXNgYp7VMF4E6eAQ/hP/DKb1tWTjsEMsoHAxdDa
 KWZeXaoD8iohvqfrB8Nb5eI/cTLJOVBqS/zlEsqIx2lWOfz3XL
 1SCWmoh7h5b2s9yEugJMpMG/LbpcSFzigEPr6PwaOv63Huyl30
 6w5icqaPH0UHv/JhKXd0/f25rWepATFDY2rQ93a7jIccNf9IAq
 KUULiZSwMqlgWer/umHpmyab7hoPkuebyysfyLKXQB4CxWsFxi
 g2vo3lrOd5mULzsDV948=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 October 2011 16:31:50 Tim Bird wrote:
> 
> This tool can be used to analyze the function stack size for ARM kernels,
> statically, based on a disassembly of vmlinux (or an individual .o file
> 
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>

Hi Tim,

I thought we now had a gcc option for this. gcc documentation points to -Wstack-usage=XXX.
This was first introduced on s390 in architecture specific gcc code, but should now work
everywhere.

	Arnd
