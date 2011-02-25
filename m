Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab1BYPiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:38:46 -0500
Received: from www.tglx.de ([62.245.132.106]:37173 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab1BYPip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:38:45 -0500
Message-ID: <4D67CCF4.8030902@linutronix.de>
Date: Fri, 25 Feb 2011 16:38:28 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: linux-kernel@vger.kernel.org,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Andres Salomon <dilinger@queued.net>, tglx@linutronix.de
Subject: Re: OF IOAPIC bindings compile error
References: <AANLkTin-2FH-c_5DVpW29zvARW827Ebun31=z2b+jB00@mail.gmail.com>
In-Reply-To: <AANLkTin-2FH-c_5DVpW29zvARW827Ebun31=z2b+jB00@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake wrote:
> Hi,
Hi,

> 
> Testing linux-2.6-x86.git, I encountered a compile error which seems
> to caused by the following commit with X86_IO_APIC=n:
> 
> commit bcc7c1244fcfd852b9f4590935491057e1cab9dd
> Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Date:   Tue Feb 22 21:07:44 2011 +0100
> 
>     x86: ioapic: Add OF bindings for IO_APIC

Please check:
Commit-ID:  a906fdaacca49917d83e5032dfc31f694249ad10
Gitweb:     http://git.kernel.org/tip/a906fdaacca49917d83e5032dfc31f694249ad10
x86: dt: Cleanup local apic setup

this fixes it.

> Daniel

Sebastian
