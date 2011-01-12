Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab1ALPQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:16:59 -0500
Received: from cantor.suse.de ([195.135.220.2]:53422 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab1ALPQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:16:57 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 3/9] X86/perf: fix power:cpu_idle double end events and throw cpu_idle events from the cpuidle layer
Date: Wed, 12 Jan 2011 16:16:54 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-18-desktop; KDE/4.5.3; x86_64; ; )
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        j-pihet@ti.com, Robert Schoene <robert.schoene@tu-dresden.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
References: <1294396190-23031-1-git-send-email-trenn@suse.de> <1294396190-23031-4-git-send-email-trenn@suse.de> <alpine.LFD.2.02.1101120141330.19140@x980>
In-Reply-To: <alpine.LFD.2.02.1101120141330.19140@x980>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101121616.54613.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 January 2011 07:42:59 Len Brown wrote:
> I'm happy to see the trace point move up into cpuidle from intel_idle.
> 
> If somebody is picking this up in a perf tree,
> Acked-by: Len Brown <len.brown@intel.com>
> 
> else I can put it in the idle tree, let me know.
I didn't know you have an idle tree.

If you can push this one through the idle tree that would be great.

I'll go through the rest of my patches and resubmit
in some days as soon as some things are clarified.

But I need this one to still be included in .38.
Please tell me if this could be a problem.

Thanks,

  Thomas
