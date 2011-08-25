Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab1HYCOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 22:14:36 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:46400 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752902Ab1HYCOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 22:14:35 -0400
Date: Wed, 24 Aug 2011 19:14:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Cong Wang <amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [Patch] numa: introduce CONFIG_NUMA_SYSFS for
 drivers/base/node.c
Message-Id: <20110824191430.8a908e70.rdunlap@xenotime.net>
In-Reply-To: <4E547155.8090709@redhat.com>
References: <20110804145834.3b1d92a9eeb8357deb84bf83@canb.auug.org.au>
	<20110804152211.ea10e3e7.rdunlap@xenotime.net>
	<20110823143912.0691d442.akpm@linux-foundation.org>
	<4E547155.8090709@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011 11:34:45 +0800 Cong Wang wrote:

> Hi, Andrew,
> 
> Do you think my patch below is better?

Hi,

This causes build errors for me because node.o is not being built:

arch/x86/built-in.o: In function `topology_init':
topology.c:(.init.text+0x3668): undefined reference to `register_one_node'
drivers/built-in.o: In function `unregister_cpu':
(.text+0x7aecc): undefined reference to `unregister_cpu_under_node'
drivers/built-in.o: In function `register_cpu':
(.cpuinit.text+0xc1): undefined reference to `register_cpu_under_node'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
