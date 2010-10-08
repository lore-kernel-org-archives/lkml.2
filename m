Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab0JHMiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 08:38:01 -0400
Received: from 26.mail-out.ovh.net ([91.121.27.225]:51776 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755925Ab0JHMiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 08:38:00 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Oct 2010 08:37:59 EDT
Date: Fri, 8 Oct 2010 14:29:18 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Anders Larsen <al@alarsen.net>
Cc: patches@arm.linux.org.uk, Andrew Victor <avictor.za@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: AT91: Fix power-saving in idle-mode on 926T processors
Message-ID: <20101008122918.GA30252@game.jcrosoft.org>
References: <20101007194415.GA24709@alarsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007194415.GA24709@alarsen.net>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 1086774885601815369
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:44 Thu 07 Oct     , Anders Larsen wrote:
> According to Atmel, their 926T processors (AT91 post RM9200) requires
> 'Wait for Interrupt' mode be entered right after disabling the processor clock
> in order to minimise current consumption when idle, so do both provided we're
> not running on a 920T (an RM9200).
> 
> Furthermore, get rid of the #ifndef CONFIG_DEBUG_KERNEL, since arch_idle()
> can be turned off completely with the kernel parameter 'nohlt'.
> 
> Signed-off-by: Anders Larsen <al@alarsen.net>
> Cc: Andrew Victor <avictor.za@gmail.com>
please rebase against this branch

git://github.com/at91linux/linux-2.6-at91.git branch for-rmk

Best Regards,
J.
