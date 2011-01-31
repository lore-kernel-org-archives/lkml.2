Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab1AaWbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:31:11 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46647 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab1AaWbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:31:10 -0500
Date: Mon, 31 Jan 2011 22:31:03 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH -mmotm] backlight: apple_bl depends on ACPI
Message-ID: <20110131223103.GA15093@srcf.ucam.org>
References: <201101260021.p0Q0LxsS016458@imap1.linux-foundation.org> <20110126111602.7bfea64e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126111602.7bfea64e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 11:16:02AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> apple_bl uses ACPI interfaces (data & code), so it should depend on ACPI.
> 
> drivers/video/backlight/apple_bl.c:142: warning: 'struct acpi_device' declared inside parameter list
> drivers/video/backlight/apple_bl.c:142: warning: its scope is only this definition or declaration, which is probably not what you want
> drivers/video/backlight/apple_bl.c:201: warning: 'struct acpi_device' declared inside parameter list
> drivers/video/backlight/apple_bl.c:215: error: variable 'apple_bl_driver' has initializer but incomplete type
> drivers/video/backlight/apple_bl.c:216: error: unknown field 'name' specified in initializer
> drivers/video/backlight/apple_bl.c:216: warning: excess elements in struct initializer
> drivers/video/backlight/apple_bl.c:216: warning: (near initialization for 'apple_bl_driver')
> drivers/video/backlight/apple_bl.c:217: error: unknown field 'ids' specified in initializer
> drivers/video/backlight/apple_bl.c:217: warning: excess elements in struct initializer
> drivers/video/backlight/apple_bl.c:217: warning: (near initialization for 'apple_bl_driver')
> drivers/video/backlight/apple_bl.c:218: error: unknown field 'ops' specified in initializer
> drivers/video/backlight/apple_bl.c:218: error: extra brace group at end of initializer
> drivers/video/backlight/apple_bl.c:218: error: (near initialization for 'apple_bl_driver')
> drivers/video/backlight/apple_bl.c:221: warning: excess elements in struct initializer
> drivers/video/backlight/apple_bl.c:221: warning: (near initialization for 'apple_bl_driver')
> drivers/video/backlight/apple_bl.c:226: error: implicit declaration of function 'acpi_bus_register_driver'
> drivers/video/backlight/apple_bl.c:231: error: implicit declaration of function 'acpi_bus_unregister_driver'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>

Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
