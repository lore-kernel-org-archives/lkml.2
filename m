Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1KUPrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:47:10 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:38778 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab1KUPrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:47:08 -0500
Message-ID: <8be4650484e8827410219db85531ecaf.squirrel@webmail.sf-mail.de>
In-Reply-To: <C27E2EE4-3534-4FC2-997A-0F090BF2AAF5@gmail.com>
References: <B458B2F0-2DDA-461F-A125-8C6C4CDEB6C5@gmail.com>
    <20111118222718.GF22904@local>
    <C27E2EE4-3534-4FC2-997A-0F090BF2AAF5@gmail.com>
Date: Mon, 21 Nov 2011 16:47:06 +0100
Subject: Re: extra large DMA buffer for PCI-E device under UIO
From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
To: "Jean-Francois Dagenais" <jeff.dagenais@gmail.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, gregkh@suse.de, tglx@linutronix.de,
        linux-pci@vger.kernel.org, "open list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The pci ID we use is not registered, and except for this driver, which
> is a non-driver really (UIO), the FPGA firmware and the userspace code is
> proprietary.

Why keep people doing this? This is just asking for future trouble. And it
gives bad karma.

Go and ask your FPGA vendor to assign a device id to you. At least for
Xilinx this has worked.

Eike
