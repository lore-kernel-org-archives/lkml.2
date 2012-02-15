Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab2BOSy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 13:54:58 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63509 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab2BOSy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 13:54:57 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVMfmabcH57da-prx=J950KEoFtfb-zsuBWn7VY3NaMUUQ@mail.gmail.com>
References: <20120208124147.GF16334@legolas.emea.dhcp.ti.com>
	<CACVXFVMfmabcH57da-prx=J950KEoFtfb-zsuBWn7VY3NaMUUQ@mail.gmail.com>
Date: Wed, 15 Feb 2012 19:54:56 +0100
Message-ID: <CACRpkdZ7bs=i6Zg1ckXk-xBhY9z5VbvhVMk7p2_kP-=eB2bCKw@mail.gmail.com>
Subject: Re: Possible circular locking dependency (3.3-rc2)
From: Linus Walleij <linus.walleij@linaro.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: balbi@ti.com, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 3:53 PM, Ming Lei <tom.leiming@gmail.com> wrote:

> Looks 'sysfs_lock' needn't to be held for unregister, so the patch below may
> fix the problem.

Looks correct to me!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
