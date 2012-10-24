Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161078Ab2JXS1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:27:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38951 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935245Ab2JXS1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:27:51 -0400
Date: Wed, 24 Oct 2012 11:27:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
        xemul@parallels.com, jslaby@suse.cz
Subject: Re: [patch 1/3] tty: pty - Move TIOCPKT handling into pty.c
Message-ID: <20121024182747.GA2614@kroah.com>
References: <20120927211032.576475929@openvz.org>
 <20120927211121.651422569@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120927211121.651422569@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 01:10:33AM +0400, Cyrill Gorcunov wrote:
> Since this ioctl is for pty devices only move it to pty.c.
> 
> v2:
>  - drop PTY_TYPE_MASTER test since it's master peer
>    ioctl anyway (by jslaby@)

This patch adds the compiler warning:
drivers/tty/tty_ioctl.c: In function ‘n_tty_ioctl_helper’:
drivers/tty/tty_ioctl.c:1121:16: warning: unused variable ‘flags’ [-Wunused-variable]

Care to fix it up and resend?

thanks,

greg k-h
