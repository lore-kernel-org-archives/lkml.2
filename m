Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab2CHR4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 12:56:53 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47010 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab2CHR4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 12:56:50 -0500
Date: Thu, 8 Mar 2012 09:56:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH] staging: ram_console: Fix section mismatches
Message-ID: <20120308175645.GA22682@kroah.com>
References: <1331170478-30538-1-git-send-email-john.stultz@linaro.org>
 <1331197684-9163-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331197684-9163-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 01:08:04AM -0800, Stephen Boyd wrote:
> WARNING: vmlinux.o(.text+0x25d5fc): Section mismatch in reference
> from the function ram_console_driver_probe() to the function
> .init.text:ram_console_init()
> The function ram_console_driver_probe() references
> the function __init ram_console_init().
> This is often because ram_console_driver_probe lacks a __init
> annotation or the annotation of ram_console_init is wrong.
> 
> Mark ram_console_driver_probe() as __devinit because it's a probe
> function and propagate the __devinit markings to the __init
> functions the probe calls.

What .config configuration causes this to happen?  I don't see this here
in my builds, what am I doing wrong?

thanks,

greg k-h
