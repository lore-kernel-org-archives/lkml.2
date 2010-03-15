Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab0COPeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:34:01 -0400
Received: from [85.183.11.32] ([85.183.11.32]:52301 "EHLO Dublin.logfs.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab0COPd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:33:58 -0400
X-Greylist: delayed 1481 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2010 11:33:58 EDT
Date: Mon, 15 Mar 2010 16:10:41 +0100
From: =?utf-8?Q?J=F6rn?= Engel <joern@dublin.logfs.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Regression] r8169: enable 64-bit DMA by default for PCI
	Express devices (v2)
Message-ID: <20100315151041.GA15667@Dublin.logfs.org>
References: <20100315150806.GA15354@Dublin.logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100315150806.GA15354@Dublin.logfs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to Cc: lkml.

On Mon, 15 March 2010 16:08:06 +0100, J�rn Engel wrote:
> 
> Hello Robert!
> 
> Looks like 353176888386d9025062a12dcec08d49af10cf2c broke one of my
> machines.  Reverting that patch fixes things again.  Machine is
> running an x86_64 kernel.  Lspci gives me this:
> 
> 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
>         Subsystem: ASRock Incorporation Device 8136
>         Flags: bus master, fast devsel, latency 0, IRQ 26
>         I/O ports at e800 [size=256]
>         Memory at fdeff000 (64-bit, prefetchable) [size=4K]
>         Memory at fdee0000 (64-bit, prefetchable) [size=64K]
>         [virtual] Expansion ROM at fde00000 [disabled] [size=128K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
>         Capabilities: [70] Express Endpoint, MSI 01
>         Capabilities: [ac] MSI-X: Enable- Count=2 Masked-
>         Capabilities: [cc] Vital Product Data
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [140] Virtual Channel <?>
>         Capabilities: [160] Device Serial Number 08-00-00-00-ff-ff-00-00
>         Kernel driver in use: r8169
> 
> If you have any test patches to try, please send them my way. :)
> 
> J�rn
