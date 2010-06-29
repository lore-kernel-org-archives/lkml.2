Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab0F2PD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:03:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41070 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab0F2PD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:03:57 -0400
Date: Tue, 29 Jun 2010 08:02:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rudolf Marek <r.marek@assembler.cz>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org, Huaxu Wan <huaxu.wan@intel.com>
Subject: Re: linux-next: Tree for June 29 (hwmon/coretemp)
Message-Id: <20100629080257.43b365dd.randy.dunlap@oracle.com>
In-Reply-To: <20100629151938.6981044d.sfr@canb.auug.org.au>
References: <20100629151938.6981044d.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C2A0B37.01E1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jun 2010 15:19:38 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100628:
> 
> My fixes tree is now empty.


when CONFIG_SMP is not enabled:

drivers/hwmon/coretemp.c:308: error: 'struct cpuinfo_x86' has no member named 'cpu_core_id'
drivers/hwmon/coretemp.c:428: error: 'struct cpuinfo_x86' has no member named 'phys_proc_id'
drivers/hwmon/coretemp.c:429: error: 'struct cpuinfo_x86' has no member named 'cpu_core_id'
drivers/hwmon/coretemp.c:457: error: 'struct cpuinfo_x86' has no member named 'phys_proc_id'
drivers/hwmon/coretemp.c:458: error: 'struct cpuinfo_x86' has no member named 'cpu_core_id'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
