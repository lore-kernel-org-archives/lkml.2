Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab1EZQOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:14:47 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:52758 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758054Ab1EZQOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:14:46 -0400
From: Kevin Hilman <khilman@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@fluxnic.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
Organization: Texas Instruments, Inc.
References: <201105181047.17309.arnd@arndb.de>
Date: Thu, 26 May 2011 09:14:42 -0700
In-Reply-To: <201105181047.17309.arnd@arndb.de> (Arnd Bergmann's message of
	"Wed, 18 May 2011 10:47:16 +0200")
Message-ID: <87k4ddiglp.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> This is the draft plan for maintaining the ARM subarchitectures in a common
> tree, as a way to help coordinate the upstream merging of the
> arch/arm/{plat,mach}-* changes into Linus' tree.

[...]

>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
>
> ---
>
> Maintainers: If you are happy with the layout of the process,
> please ack this patch, otherwise please comment.

Acked-by: Kevin Hilman <khilman@ti.com>

for davinci and OMAP stuff I maintain.

Kevin
