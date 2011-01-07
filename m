Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab1AGRS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:18:56 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:36154 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab1AGRSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:18:55 -0500
Date: Fri, 7 Jan 2011 09:18:34 -0800
From: Randy Dunlap <randy.dunlap@Oracle.com>
To: akpm@linux-foundation.org, mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-01-06-15-41 uploaded (apple_bl)
Message-Id: <20110107091834.47786e35.randy.dunlap@oracle.com>
In-Reply-To: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Jan 2011 15:41:14 -0800 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2011-01-06-15-41 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.37:


When ACPI is not enabled:

drivers/video/backlight/apple_bl.c:142: warning: 'struct acpi_device' declared inside parameter list
drivers/video/backlight/apple_bl.c:142: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/video/backlight/apple_bl.c:200: warning: 'struct acpi_device' declared inside parameter list
drivers/video/backlight/apple_bl.c:214: error: variable 'apple_bl_driver' has initializer but incomplete type
drivers/video/backlight/apple_bl.c:215: error: unknown field 'name' specified in initializer
drivers/video/backlight/apple_bl.c:215: warning: excess elements in struct initializer
drivers/video/backlight/apple_bl.c:215: warning: (near initialization for 'apple_bl_driver')
drivers/video/backlight/apple_bl.c:216: error: unknown field 'ids' specified in initializer
drivers/video/backlight/apple_bl.c:216: warning: excess elements in struct initializer
drivers/video/backlight/apple_bl.c:216: warning: (near initialization for 'apple_bl_driver')
drivers/video/backlight/apple_bl.c:217: error: unknown field 'ops' specified in initializer
drivers/video/backlight/apple_bl.c:217: error: extra brace group at end of initializer
drivers/video/backlight/apple_bl.c:217: error: (near initialization for 'apple_bl_driver')
drivers/video/backlight/apple_bl.c:220: warning: excess elements in struct initializer
drivers/video/backlight/apple_bl.c:220: warning: (near initialization for 'apple_bl_driver')
drivers/video/backlight/apple_bl.c: In function 'apple_bl_init':
drivers/video/backlight/apple_bl.c:225: error: implicit declaration of function 'acpi_bus_register_driver'
drivers/video/backlight/apple_bl.c: In function 'apple_bl_exit':
drivers/video/backlight/apple_bl.c:230: error: implicit declaration of function 'acpi_bus_unregister_driver'


Should BACKLIGHT_APPLE also depend on ACPI?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
