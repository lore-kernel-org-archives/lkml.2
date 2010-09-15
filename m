Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0IOQAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 12:00:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34288 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab0IOQAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 12:00:49 -0400
Date: Wed, 15 Sep 2010 08:59:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 15 (bkl-related)
Message-Id: <20100915085910.a137904f.randy.dunlap@oracle.com>
In-Reply-To: <20100915142954.6a36f52d.sfr@canb.auug.org.au>
References: <20100915142954.6a36f52d.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 14:29:54 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100914:
> 
> New Trees:
> 	bkl-config
> 	bkl-trivial
> 	bkl-llseek
> 	bkl-vfs
> 
> Removed trees:  (at maintainer's request)
> 	limits
> 	bkl-core
> 	bkl-procfs
> 	bkl-ioctl
> 
> The bkl-trivial tree gained a conflict against Linus' tree.
> 
> The bkl-llseek tree gained a conflict against the rr tree.
> 
> The bkl-vfs tree gained conflicts against the usb and nilfs2 trees.
> 
> ----------------------------------------------------------------------------

(1)
drivers/pnp/isapnp/proc.c:50: error: expected '}' before 'else'

(2) when CONFIG_SCSI_PROC_FS is not enabled:
drivers/scsi/sg.c:233: error: 'sg_mutex' undeclared (first use in this function)
drivers/scsi/sg.c:1096: error: 'sg_mutex' undeclared (first use in this function)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
