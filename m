Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964894Ab2JZPtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:49:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:34855 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874Ab2JZPtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:49:21 -0400
Date: Fri, 26 Oct 2012 17:49:19 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Florian Fainelli <ffainelli@freebox.fr>
Cc: linux-kernel@vger.kernel.org, x86@vger.kernel.org, mbizon@freebox.fr,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH 3/3] x86: ce4100: fixup PCI configuration register
 access for devices without interrupts
Message-ID: <20121026154919.GA8459@linutronix.de>
References: <1350647516-4842-1-git-send-email-ffainelli@freebox.fr>
 <1350647516-4842-4-git-send-email-ffainelli@freebox.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1350647516-4842-4-git-send-email-ffainelli@freebox.fr>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Florian Fainelli | 2012-10-19 13:51:56 [+0200]:

>From: Maxime Bizon <mbizon@freebox.fr>
>
>Some CE4100 devices such as the:
>- DFX module (01:0b.7)
>- entertainment encryption device (01:10.0)
>- multimedia controller (01:12.0)
>
>do not have a device interrupt at all. This patch fixes the PCI controller
>code to declare the missing PCI configuration register space, as well as a
>fixup method for forcing the interrupt pin to be 0 for these devices. This is
>required to ensure that pci drivers matching on these devices will be able to
>call honor the various PCI subsystem calls touching the configuration space.

So they realy don't have an Interrupt. I assumed that I was not good
enough reading the table and matching the entries to the HW.

>Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

for patches 1-3

Sebastian
