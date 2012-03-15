Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031046Ab2COPn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:43:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51440 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030466Ab2COPn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:43:27 -0400
Date: Thu, 15 Mar 2012 08:43:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] driver core: always handle dpm_order
Message-ID: <20120315154323.GB23589@kroah.com>
References: <1331805498-12903-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331805498-12903-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 10:58:18AM +0100, Linus Walleij wrote:
> From: Rabin Vincent <rabin.vincent@stericsson.com>
> 
> If !dev->class, device_move() does not respect the dpm_order.
> Fix it to do so.

Is there code today in the kernel that needs this to go in now?  For
older releases?  Or is 3.4 acceptable?

thanks,

greg k-h
