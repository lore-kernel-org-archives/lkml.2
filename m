Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2DCWJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:09:54 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:54647 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2DCWJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 18:09:53 -0400
Date: Tue, 3 Apr 2012 15:09:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Geon Si Jeong <gshark.jeong@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] leds: Add LED driver for lm3556 chip
Message-ID: <20120403220946.GA6022@kroah.com>
References: <1333089508-8501-1-git-send-email-gshark.jeong@gmail.com>
 <1333089508-8501-2-git-send-email-gshark.jeong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333089508-8501-2-git-send-email-gshark.jeong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 03:38:28PM +0900, Geon Si Jeong wrote:
> It is a simple driver for LM3556 Chip(Texas Instruments)
> LM3556 :
> The LM3556 is a 4 MHz fixed-frequency synchronous boost
> converter plus 1.5A constant current driver for a high-current white LED.
> Datasheet: www.national.com/ds/LM/LM3556.pdf
> 
> Tested on OMAP4430
> 
> Signed-off-by: Geon Si Jeong <gshark.jeong@gmail.com>
> ---
>  drivers/leds/Kconfig        |    9 +
>  drivers/leds/Makefile       |    2 +-
>  drivers/leds/leds-lm3556.c  |  462 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/leds-lm3556.h |  242 ++++++++++++++++++++++

Why does this .h file have to be in include/linux/ ?

Why does it need to be a .h file at all?  Why can't it be part of the .c
file?

Only put files in include/linux/ that other files outside of your local
directory, need to access, and only put stuff in those files that other
files need to have.

thanks,

greg k-h
