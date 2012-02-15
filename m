Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab2BOIgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 03:36:23 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60291 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab2BOIgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 03:36:22 -0500
Date: Wed, 15 Feb 2012 08:36:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nathaniel Husted <nhusted@gmail.com>,
        Eric Paris <eparis@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: ptrace: Include linux/audit.h to fix build errors
Message-ID: <20120215083609.GD13673@n2100.arm.linux.org.uk>
References: <1329284188.12708.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329284188.12708.1.camel@phoenix>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 01:36:28PM +0800, Axel Lin wrote:
> Include linux/audit.h to fix below build errors:
> 
>   CC      arch/arm/kernel/ptrace.o
> arch/arm/kernel/ptrace.c: In function 'syscall_trace':
> arch/arm/kernel/ptrace.c:919: error: implicit declaration of function 'audit_syscall_exit'
> arch/arm/kernel/ptrace.c:921: error: implicit declaration of function 'audit_syscall_entry'
> arch/arm/kernel/ptrace.c:921: error: 'AUDIT_ARCH_ARMEB' undeclared (first use in this function)

Err, can someone explain why we seem to tell the audit code that we're
always big endian?
