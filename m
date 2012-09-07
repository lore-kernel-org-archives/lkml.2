Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab2IGCqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:46:19 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40485 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab2IGCqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:46:18 -0400
Date: Thu, 6 Sep 2012 19:46:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Tomas Hlavacek <tmshlvck@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: tty: WARNING at drivers/base/core.c:196 device_release()
Message-ID: <20120907024613.GA28505@kroah.com>
References: <20120907022928.GA14646@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907022928.GA14646@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 10:29:28AM +0800, Fengguang Wu wrote:
> Hi Tomas,
> 
> FYI, this commit triggers a boot time warning.
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git tty-next
> head:   6915c0e487c822e2436683e14302c0b8a6155cc7
> commit: 6915c0e487c822e2436683e14302c0b8a6155cc7 [1/1] tty: uartclk value from serial_core exposed to sysfs

Should now be fixed in my tree with a later patch, from Tomas, right?

thanks,

greg k-h
