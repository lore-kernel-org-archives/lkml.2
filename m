Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab0ERUO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:14:59 -0400
Received: from kroah.org ([198.145.64.141]:52570 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758073Ab0ERUOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:14:17 -0400
Date: Tue, 18 May 2010 13:07:30 -0700
From: Greg KH <greg@kroah.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs
Message-ID: <20100518200730.GB20223@kroah.com>
References: <1274233602.3036.84.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274233602.3036.84.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 01:46:42AM +0000, Lin Ming wrote:
> +struct kobj_type event_ktype = {
> +	.sysfs_ops	= &event_sysfs_ops,
> +};

No release function?  Hm, are you setting yourself up to be publically
made fun of?  You have read the kobject documentation about this, right?
Have you looked at the kernel logs for when you try to free this object?

thanks,

greg k-h
