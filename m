Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab0K3T5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:57:51 -0500
Received: from relais.videotron.ca ([24.201.245.36]:36170 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab0K3T5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:57:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 30 Nov 2010 14:57:48 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mike Frysinger <vapier@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] drivers: char: hvc: add arm JTAG DCC console support
In-reply-to: <1291145141-18301-1-git-send-email-dwalker@codeaurora.org>
Message-id: <alpine.LFD.2.00.1011301455400.9313@xanadu.home>
References: <1291145141-18301-1-git-send-email-dwalker@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Daniel Walker wrote:

> This driver adds a basic console that uses the arm JTAG
> DCC to transfer data back and forth. It has support for
> ARMv6 and ARMv7.
> 
> This console is created under the HVC driver, and should be named
> /dev/hvcX (or /dev/hvc0 for example).
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Daniel Walker <dwalker@codeaurora.org>

Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>

This doesn't support both ARMv6 and ARMv7 at run time, but this can 
trivially be added later when needed.


Nicolas
