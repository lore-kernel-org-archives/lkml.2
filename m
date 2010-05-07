Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab0EGS06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:26:58 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42098 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab0EGS04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:26:56 -0400
Date: Fri, 7 May 2010 19:26:47 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH -next] eeepc-wmi: depends on BACKLIGHT_CLASS_DEVICE
Message-ID: <20100507182647.GC24478@srcf.ucam.org>
References: <20100507155520.75026a8b.sfr@canb.auug.org.au> <20100507112411.0212242d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507112411.0212242d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 11:24:11AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> eeepc-wmi uses backlight*() interfaces so it should depend on
> BACKLIGHT_CLASS_DEVICE.
> 
> eeepc-wmi.c:(.text+0x2d7f54): undefined reference to `backlight_force_update'
> eeepc-wmi.c:(.text+0x2d8012): undefined reference to `backlight_device_register'
> eeepc-wmi.c:(.devinit.text+0x1c31c): undefined reference to `backlight_device_unregister'
> eeepc-wmi.c:(.devexit.text+0x2f8b): undefined reference to `backlight_device_unregister'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, applied for -next. I'll send this one for .34 as well.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
