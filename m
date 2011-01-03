Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1ACV1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 16:27:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49696
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668Ab1ACV1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 16:27:20 -0500
Date: Mon, 03 Jan 2011 13:27:50 -0800 (PST)
Message-Id: <20110103.132750.241921691.davem@davemloft.net>
To: sedat.dilek@googlemail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sedat.dilek@gmail.com
Subject: Re: [PATCH] ksz884x: Fix section mismatch derived from
 pcidev_init()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1294088818-2903-1-git-send-email-sedat.dilek@gmail.com>
References: <1294088818-2903-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sedat Dilek <sedat.dilek@googlemail.com>
Date: Mon,  3 Jan 2011 22:06:58 +0100

> This fixes the following warning:
> 
> WARNING: drivers/net/ksz884x.o(.data+0x18): Section mismatch in reference from the variable pci_device_driver to the function .init.text:pcidev_init()
> The variable pci_device_driver references
> the function __init pcidev_init()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> Tested with linux-next (next-20101231)
> 
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>

Applied.
