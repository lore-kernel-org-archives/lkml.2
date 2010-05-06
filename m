Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab0EFU0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 16:26:25 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:58805 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810Ab0EFU0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 16:26:24 -0400
Date: Thu, 06 May 2010 16:26:13 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] linux-next: Tree for May 6 (acpi: PM=n)
In-reply-to: <20100506080538.b566f50e.randy.dunlap@oracle.com>
Message-id: <alpine.LFD.2.00.1005061623060.15286@localhost.localdomain>
References: <20100506151502.f97afe54.sfr@canb.auug.org.au>
 <20100506080538.b566f50e.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When CONFIG_PM is not set:
> 
> drivers/built-in.o: In function `acpi_init':
> bus.c:(.init.text+0x2d84): undefined reference to `pm_flags'
> bus.c:(.init.text+0x2d91): undefined reference to `pm_flags'

CONFIG_ACPI depends on CONFIG_PM,
so acpi/bus.c should not be compiled for CONFIG_PM=n

Hmm, is is somebody doing something strange, like "select ACPI"
without guaranteeing that all of ACPI's dependencies are satisfied?

thanks,
Len Brown, Intel Open Source Technology Center

