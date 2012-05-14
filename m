Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab2ENNPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:15:00 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:41396 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756045Ab2ENNO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:14:59 -0400
Date: Mon, 14 May 2012 15:14:54 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH -next] via_wdt: depends on PCI
Message-ID: <20120514131454.GG3074@spo001.leaseweb.com>
References: <20120511162738.1d65b6efe099a54841be6313@canb.auug.org.au> <4FADA2B2.8070302@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FADA2B2.8070302@xenotime.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rancy,

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> via_wdt is a PCI driver so it should depend on PCI so that
> it will not cause build errors.
> 
> drivers/watchdog/via_wdt.c:256:1: warning: data definition has no type or storage class
> drivers/watchdog/via_wdt.c:256:1: warning: type defaults to 'int' in declaration of 'module_pci_driver'
> drivers/watchdog/via_wdt.c:256:1: warning: parameter names (without types) in function declaration
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Fix added.

Thanks,
Wim.

