Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0IPTwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:52:06 -0400
Received: from kroah.org ([198.145.64.141]:39105 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab0IPTwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:52:03 -0400
Date: Thu, 16 Sep 2010 12:33:33 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] staging: cx25821 and go7007 depend on IR_CORE
Message-ID: <20100916193333.GE10397@kroah.com>
References: <20100914135802.c99d3672.sfr@canb.auug.org.au>
 <20100914152359.f871d000.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914152359.f871d000.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 03:23:59PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build errors in cx25821 and go7007.
> They both use IR functions, so they should depend on IR_CORE.
> (It's not safe to select VIDEO_IR when IR_CORE is not enabled.)
> 
> (.text+0x39065a): undefined reference to `ir_core_debug'
> (.text+0x3906a4): undefined reference to `ir_core_debug'
> ir-functions.c:(.text+0x39080b): undefined reference to `ir_core_debug'
> (.text+0x390893): undefined reference to `ir_g_keycode_from_table'
> (.text+0x390942): undefined reference to `ir_core_debug'
> (.text+0x3909f5): undefined reference to `ir_core_debug'
> (.text+0x390a3a): undefined reference to `ir_core_debug'
> (.text+0x390ab1): undefined reference to `ir_core_debug'
> (.text+0x390b36): undefined reference to `ir_core_debug'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: devel@driverdev.osuosl.org
> ---
>  drivers/staging/cx25821/Kconfig |    2 +-
>  drivers/staging/go7007/Kconfig  |    2 +-

These need to go to Mauro.

thanks,

greg k-h
