Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0KJBIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:08:06 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:28178 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab0KJBID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:08:03 -0500
Date: Tue, 9 Nov 2010 17:06:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Zhang Rui <rui.zhang@intel.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: linux-next: Tree for November 9 (acpi_video)
Message-Id: <20101109170621.32db3873.randy.dunlap@oracle.com>
In-Reply-To: <20101109151618.a562f77a.sfr@canb.auug.org.au>
References: <20101109151618.a562f77a.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010 15:16:18 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101029:


one build had these errors:

drivers/built-in.o: In function `acpi_video_bus_put_one_device':
video.c:(.text+0x59bee): undefined reference to `thermal_cooling_device_unregister'
video.c:(.text+0x59bff): undefined reference to `video_output_unregister'
drivers/built-in.o: In function `acpi_video_device_find_cap':
video.c:(.text+0x5b3fc): undefined reference to `thermal_cooling_device_register'
video.c:(.text+0x5b57b): undefined reference to `video_output_register'

and another one had these errors:

drivers/built-in.o: In function `acpi_video_bus_put_one_device':
video.c:(.text+0xdc14a): undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `acpi_video_switch_brightness':
video.c:(.text+0xdc821): undefined reference to `backlight_force_update'
drivers/built-in.o: In function `acpi_video_device_find_cap':
video.c:(.text+0xdd8bd): undefined reference to `backlight_device_register'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
