Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0L0TXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 14:23:51 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:46928 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab0L0TXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 14:23:49 -0500
Date: Mon, 27 Dec 2010 11:21:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        nab@kernel.org
Subject: Re: linux-next: Tree for December 27 (drivers/target/)
Message-Id: <20101227112114.634c6e60.randy.dunlap@oracle.com>
In-Reply-To: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Dec 2010 17:04:51 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> [The mirroring on kernel.org is running slowly]

yep :(

> Changes since 20101221:


When CONFIG_SCSI is not enabled:

ERROR: "scsi_device_type" [drivers/target/target_core_mod.ko] undefined!

from target_core_transport.c::1586:

	printk("  Type:   %s ", scsi_device_type(device_type));


Also please update MAINTAINERS for drivers/target/.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
