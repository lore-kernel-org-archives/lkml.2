Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1ALGnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 01:43:22 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:64679 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1ALGnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 01:43:19 -0500
Date: Wed, 12 Jan 2011 01:42:59 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Thomas Renninger <trenn@suse.de>
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        j-pihet@ti.com, Robert Schoene <robert.schoene@tu-dresden.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 3/9] X86/perf: fix power:cpu_idle double end events and
 throw cpu_idle events from the cpuidle layer
In-reply-to: <1294396190-23031-4-git-send-email-trenn@suse.de>
Message-id: <alpine.LFD.2.02.1101120141330.19140@x980>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
 <1294396190-23031-4-git-send-email-trenn@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm happy to see the trace point move up into cpuidle from intel_idle.

If somebody is picking this up in a perf tree,
Acked-by: Len Brown <len.brown@intel.com>

else I can put it in the idle tree, let me know.

thanks,
Len Brown, Intel Open Source Technology Center

