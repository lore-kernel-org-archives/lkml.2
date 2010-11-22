Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab0KVEe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 23:34:28 -0500
Received: from kroah.org ([198.145.64.141]:41419 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580Ab0KVEe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 23:34:28 -0500
Date: Sun, 21 Nov 2010 20:35:20 -0800
From: Greg KH <greg@kroah.com>
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.37-rc3 problems
Message-ID: <20101122043520.GA10958@kroah.com>
References: <web-407197955@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <web-407197955@zbackend1.aha.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 11:20:40PM -0400, werner wrote:
> 2.6.37-rc3 problems
>
> easycap_main.c lines 4251,4 : implicit declaration lock-kernel   ,  
> unlock_kernel
>
> (compilation error)

Either disable this driver from your .config, or enable the BKL in your
.config.  I have a pending patch to get to Linus to fix this Kconfig
issue for this driver.

Are you really using this driver?

thanks,

greg k-h
