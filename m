Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab1ALXMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 18:12:45 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:38633 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab1ALXMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 18:12:38 -0500
Date: Wed, 12 Jan 2011 18:12:15 -0500 (EST)
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
In-reply-to: <201101121616.54613.trenn@suse.de>
Message-id: <alpine.LFD.2.02.1101121806570.19754@x980>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
 <1294396190-23031-4-git-send-email-trenn@suse.de>
 <alpine.LFD.2.02.1101120141330.19140@x980> <201101121616.54613.trenn@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to idle-test

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-test

Thomas,
Please test this branch, and base your incremental patches on it.

thanks,
Len Brown, Intel Open Source Technology Center


