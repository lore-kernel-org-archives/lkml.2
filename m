Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934816Ab0GOVRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 17:17:11 -0400
Received: from claw.goop.org ([74.207.240.146]:51461 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934800Ab0GOVRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 17:17:07 -0400
Message-ID: <4C3F7AD2.8050908@goop.org>
Date: Thu, 15 Jul 2010 14:17:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Jeffrey Merkey <jeffmerkey@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.28.10 and Linux 2.6.29.6 XEN Guest Support Broken x86_64
 in 	BUILD
References: <AANLkTim2dCrCisUmunVsUoP3uSvYDvRvNPUD0eNFxPwj@mail.gmail.com>
In-Reply-To: <AANLkTim2dCrCisUmunVsUoP3uSvYDvRvNPUD0eNFxPwj@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 04:33 PM, Jeffrey Merkey wrote:
> [root@cloudstream linux-2.6.29.6]#
> [root@cloudstream linux-2.6.29.6]#
> [root@cloudstream linux-2.6.29.6]#
> [root@cloudstream linux-2.6.29.6]# make bzImage modules modules_install install
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   AS      arch/x86/xen/xen-asm_64.o
> arch/x86/xen/xen-asm_64.S: Assembler messages:
> arch/x86/xen/xen-asm_64.S:48: Error: suffix or operands invalid for `mov'
> arch/x86/xen/xen-asm_64.S:55: Error: suffix or operands invalid for `test'
> arch/x86/xen/xen-asm_64.S:72: Error: suffix or operands invalid for `mov'
> arch/x86/xen/xen-asm_64.S:90: Error: suffix or operands invalid for `test'
> arch/x86/xen/xen-asm_64.S:110: Error: suffix or operands invalid for `setz'
> arch/x86/xen/xen-asm_64.S:116: Error: suffix or operands invalid for `cmp'
> make[1]: *** [arch/x86/xen/xen-asm_64.o] Error 1
> make: *** [arch/x86/xen] Error 2
> [root@cloudstream linux-2.6.29.6]#
>   

Do you have a particular reason to be using those kernels?  They're very
old.

    J
