Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab0L1Qab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 11:30:31 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:32869 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab0L1Qa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 11:30:29 -0500
Date: Tue, 28 Dec 2010 08:29:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, nab@kernel.org,
        scsi <linux-scsi@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 28 (drivers/target/)
Message-Id: <20101228082947.70b09534.randy.dunlap@oracle.com>
In-Reply-To: <20101228173049.217c192d.sfr@canb.auug.org.au>
References: <20101228173049.217c192d.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Dec 2010 17:30:49 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> [The mirroring on kernel.org is running slowly]
> 
> Changes since 20101227:


warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)

from:

menuconfig TARGET_CORE
	tristate "Generic Target Core Mod (TCM) and ConfigFS Infrastructure"
	select CONFIGFS_FS

but CONFIGFS_FS depends on SYSFS, so TARGET_CORE should either depend on SYSFS
or (eek) it should select SYSFS.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
