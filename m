Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2GZD7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 23:59:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49557 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2GZD7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 23:59:08 -0400
Date: Wed, 25 Jul 2012 20:59:03 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: wwang <wei_wang@realsil.com.cn>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: realtek card reader core driver
Message-ID: <20120726035903.GA7235@kroah.com>
References: <1343036558-8189-1-git-send-email-wei_wang@realsil.com.cn>
 <20120723111757.GC4352@mwanda>
 <5010B576.6040600@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5010B576.6040600@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 11:11:50AM +0800, wwang wrote:
> Hi Dan:
> 
> Sorry to bother you.
> I can't find the maintainer of drivers/misc. So if I want to submit my
> driver as misc device, who should I contact to send my patch?

>From the MAINTAINERS file:

CHAR and MISC DRIVERS
M:      Arnd Bergmann <arnd@arndb.de>
M:      Greg Kroah-Hartman <gregkh@linuxfoundation.org>
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
S:      Supported
F:      drivers/char/*
F:      drivers/misc/*

But note, this is the merge window time, when patches are sent to Linus
that have been in linux-next prior to the opening of the window.  That
means I can't look at any new patches like this driver, until after
3.6-rc1 is out in a week or so.

So please be patient.

thanks,

greg k-h
