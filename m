Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab2F0Les (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 07:34:48 -0400
Received: from ac250205.ppp.asahi-net.or.jp ([183.77.250.205]:58778 "EHLO
	smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab2F0Leq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:34:46 -0400
Date: Wed, 27 Jun 2012 20:34:44 +0900
From: Mattia Dongili <malattia@linux.it>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] sonypi: Use struct dev_pm_ops for power management
Message-ID: <20120627113443.GA20597@kamineko.org>
References: <201206232346.26432.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206232346.26432.rjw@sisk.pl>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 3.5.0-rc3+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 11:46:26PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make the sonypi driver define its PM callbacks through
> a struct dev_pm_ops object rather than by using legacy PM hooks
> in struct platform_driver.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Mattia Dongili <malattia@linux.it>

> ---
> 
> Hi,
> 
> If there are no objections, I'd like to push this patch for 3.6 through
> the linux-pm tree.
> 
> Unfortunately, I don't have the hardware to test it, but I hope it is simple
> enough for code inspection to suffice.

It looks ok to me. I do have the hardware but it's very old, last time I
booted that laptop is at least 5 years ago, not even sure it still boots
actually.

I'll give it a go if I get the time but don't count too much on it so
please include this in 3.6.

Thanks!
-- 
mattia
:wq!
