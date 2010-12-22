Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab0LVEup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 23:50:45 -0500
Received: from kroah.org ([198.145.64.141]:38261 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab0LVEuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 23:50:44 -0500
Date: Tue, 21 Dec 2010 20:50:20 -0800
From: Greg KH <greg@kroah.com>
To: Melchior FRANZ <melchior.franz@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] USB: add support for Dream Cheeky DL100B Webmail
 Notifier (1d34:0004)
Message-ID: <20101222045020.GA23598@kroah.com>
References: <201012220204.33642@rk-nord.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201012220204.33642@rk-nord.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 02:04:33AM +0100, Melchior FRANZ wrote:
> Same as v2, except:
> - version number removed from usbled.c file header
> - garbage removed from corrupted diff (sorry about that)
> 
> 
> Please review yet again and consider for inclusion. (The patch is diffed
> against 2.6.36.2.)

I've applied this, but I now get the following build warning:

drivers/usb/misc/usbled.c: In function ‘change_color’:
drivers/usb/misc/usbled.c:48:6: warning: ‘retval’ may be used uninitialized in this function

Care to send a follow-on patch to fix this up?  Just set retval to 0 at
the start of that function and it should be fine.

thanks,

greg k-h
