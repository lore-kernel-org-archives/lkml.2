Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab0EUIEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:04:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42757 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab0EUIEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:04:09 -0400
Subject: Re: [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
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
In-Reply-To: <20100520231229.GB8335@kroah.com>
References: <1274233602.3036.84.camel@localhost>
	 <20100518200524.GA20223@kroah.com>
	 <1274236496.3603.22.camel@minggr.sh.intel.com>
	 <20100519024823.GA25229@kroah.com> <1274253276.5605.10124.camel@twins>
	 <20100520184213.GB21030@kroah.com> <20100520201418.GB11470@elte.hu>
	 <20100520231229.GB8335@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 10:03:58 +0200
Message-ID: <1274429038.1674.1684.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 16:12 -0700, Greg KH wrote:
> How deep in the device tree are you really going to be caring about?  It
> sounds like the large majority of events are only going to be coming
> from the "system" type objects (cpu, nodes, memory, etc.) and very few
> would be from things that we consider a 'struct device' today (like a
> pci, usb, scsi, or input, etc.) 

The general noise I hear from the hardware people is that we'll see more
and more device-level stuff - bus bridges/controller and actual devices
(GPUs, NICs etc.) will be wanting to export performance metrics.

