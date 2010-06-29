Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab0F2TFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 15:05:38 -0400
Received: from poutre.nerim.net ([62.4.16.124]:50469 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab0F2TFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 15:05:37 -0400
Date: Tue, 29 Jun 2010 21:05:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rudolf Marek <r.marek@assembler.cz>, Huaxu Wan <huaxu.wan@intel.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] linux-next: Tree for June 29 (hwmon/coretemp)
Message-ID: <20100629210532.314250ba@hyperion.delvare>
In-Reply-To: <20100629080257.43b365dd.randy.dunlap@oracle.com>
References: <20100629151938.6981044d.sfr@canb.auug.org.au>
	<20100629080257.43b365dd.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Tue, 29 Jun 2010 08:02:57 -0700, Randy Dunlap wrote:
> On Tue, 29 Jun 2010 15:19:38 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100628:
> > 
> > My fixes tree is now empty.
> 
> 
> when CONFIG_SMP is not enabled:
> 
> drivers/hwmon/coretemp.c:308: error: 'struct cpuinfo_x86' has no member named 'cpu_core_id'
> drivers/hwmon/coretemp.c:428: error: 'struct cpuinfo_x86' has no member named 'phys_proc_id'
> drivers/hwmon/coretemp.c:429: error: 'struct cpuinfo_x86' has no member named 'cpu_core_id'
> drivers/hwmon/coretemp.c:457: error: 'struct cpuinfo_x86' has no member named 'phys_proc_id'
> drivers/hwmon/coretemp.c:458: error: 'struct cpuinfo_x86' has no member named 'cpu_core_id'

Thanks for the heads up, I hadn't considered the no-SMP case. I'll take
a look immediately.

-- 
Jean Delvare
