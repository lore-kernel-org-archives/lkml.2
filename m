Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2BOUHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:07:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64025 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2BOUHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:07:34 -0500
Date: Wed, 15 Feb 2012 13:07:31 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Ming Lei <tom.leiming@gmail.com>, balbi@ti.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Possible circular locking dependency (3.3-rc2)
Message-ID: <20120215200731.GD25779@ponder.secretlab.ca>
References: <20120208124147.GF16334@legolas.emea.dhcp.ti.com>
 <CACVXFVMfmabcH57da-prx=J950KEoFtfb-zsuBWn7VY3NaMUUQ@mail.gmail.com>
 <CACRpkdZ7bs=i6Zg1ckXk-xBhY9z5VbvhVMk7p2_kP-=eB2bCKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ7bs=i6Zg1ckXk-xBhY9z5VbvhVMk7p2_kP-=eB2bCKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 07:54:56PM +0100, Linus Walleij wrote:
> On Mon, Feb 13, 2012 at 3:53 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> 
> > Looks 'sysfs_lock' needn't to be held for unregister, so the patch below may
> > fix the problem.
> 
> Looks correct to me!
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Ming, can I have a proper Signed-off-by: line from you so I can apply this
patch?

Thanks,
g.

