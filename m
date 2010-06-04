Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab0FDAVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 20:21:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:38608 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab0FDAVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 20:21:06 -0400
Date: Thu, 3 Jun 2010 21:20:39 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com, tzanussi@gmail.com
Subject: Re: how to use perf annotate on the kernel
Message-ID: <20100604002039.GC10469@ghostprotocols.net>
References: <AANLkTik2yNxwCHl7FZAyOG4Vt56RlLi59oZR5Jo6o9ox@mail.gmail.com>
 <20100603175445.GC8928@ghostprotocols.net>
 <20100603180613.GA10469@ghostprotocols.net>
 <20100603181103.GB10469@ghostprotocols.net>
 <AANLkTincvUH7p-aHsDZoThUQn_eZkdbq3A8bM5i5ytpo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTincvUH7p-aHsDZoThUQn_eZkdbq3A8bM5i5ytpo@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 03, 2010 at 08:18:04PM +0200, Stephane Eranian escreveu:
> perf annotate __lock_acquire -k /home/eranian/perfmon/official/tip/build/vmlinux
> build id event received for [kernel.kallsyms]:
> 5c110a704293a259fbe11158dc1b25107ad7a23e
> build id event received for
> /lib/modules/2.6.35-rc1-tip/kernel/arch/x86/kernel/cpu/cpufreq/mperf.ko:
> cb5
> build id event received for
> /lib/modules/2.6.35-rc1-tip/kernel/drivers/cpufreq/cpufreq_ondemand.ko:
> cdb5
> Using /home/eranian/perfmon/official/tip/build/vmlinux for symbols
> hist_entry__inc_addr_samples: ip=0xffffffff81073b36
> 0xffffffff81073b30 __lock_acquire: period++ [ip: 0xffffffff81073b36, 0x6] => 1
> hist_entry__inc_addr_samples: ip=0xffffffff81073c94
> 
> But in the end I get:
> objdump: '[kernel.kallsyms]': No such file

Reproduced, working on it now. I've been testing only with vmlinux in
the path it searches for, not by directly specifying it, will get that
fixed, thanks,

- Arnaldo
