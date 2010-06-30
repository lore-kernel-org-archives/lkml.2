Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab0F3QZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:25:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62899 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab0F3QZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:25:39 -0400
Date: Wed, 30 Jun 2010 09:24:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 30 (power: PM_SLEEP not enabled)
Message-Id: <20100630092442.fe91ea2f.randy.dunlap@oracle.com>
In-Reply-To: <20100630154401.88c9aad1.sfr@canb.auug.org.au>
References: <20100630154401.88c9aad1.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C2B6FFC.014D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 15:44:01 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100629:
> 
> The device-mapper tree gained a build failure for which I applied a merge
> fix patch.
> 
> The spi tree lost its build failure.
> 
> ----------------------------------------------------------------------------


when CONFIG_PM_SLEEP is not enabled:

kernel/power/main.c:241: error: implicit declaration of function 'pm_get_wakeup_count'
kernel/power/main.c:251: error: implicit declaration of function 'pm_save_wakeup_count'
drivers/base/power/sysfs.c:152: error: 'struct dev_pm_info' has no member named 'wakeup_count'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
