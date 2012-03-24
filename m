Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2CXHoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 03:44:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62293 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab2CXHoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 03:44:16 -0400
Date: Sat, 24 Mar 2012 08:44:12 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 0/2] tools: Add a toplevel Makefile
Message-ID: <20120324074412.GE20145@gmail.com>
References: <1332513788-9726-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332513788-9726-1-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Hi all,
> 
> here's a refreshed version from yesterday incorporating all comments and
> suggestions along with a third patch that adds a 'help' target as the
> default one causing the following below. Btw, Arnaldo, could you please
> pick those up if there are no complaints since the first patch touches
> perf and I don't have a clear idea who else to send it to anyway :).
> 
> Thanks.
> 
> $ make

Could this also be accessible via 'make tools' in the toplevel 
Makefile?

I'd love to be able to type:

  make -j tools perf install

But ... your current patches are an improvement as well, this 
list alone:

> $ make
> Possible targets:
> 
>   cpupower   - a tool for all things x86 CPU power
>   firewire   - the userspace part of nosy, an IEEE-1394 traffic sniffer
>   lguest     - a minimal 32-bit x86 hypervisor
>   perf       - Linux performance measurements tool
>   slub       - slabs reporting tool
>   turbostat  - Intel CPU idle stats and freq reporting tool
>   usb        - USB testing tools
>   virtio     - vhost test module
>   x86_energy_perf_policy - Intel energy policy tool

is already pretty useful.

Btw., please fix the perf line to say:

s/performance measurements tool/performance measurement and analysis tool

Thanks,

	Ingo
