Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab1ALWlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:41:47 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:58054 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab1ALWlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:41:45 -0500
Date: Wed, 12 Jan 2011 17:41:34 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Thomas Renninger <trenn@suse.de>
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        j-pihet@ti.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] acpi: Use ACPI C-state type instead of enumeration
 value to export cpuidle state name
In-reply-to: <201101121333.24240.trenn@suse.de>
Message-id: <alpine.LFD.2.02.1101121737170.19754@x980>
References: <1294396190-23031-1-git-send-email-trenn@suse.de>
 <201101091330.12027.trenn@suse.de> <alpine.LFD.2.02.1101120130110.19140@x980>
 <201101121333.24240.trenn@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

I think the ACPI C-state names are fine the way they are.

I don't understand the value proposition you have presented
to replace the C-state names with ACPI C-state types.

I think this would be extremely confusing, particularly
since it would mean that multiple states can then appear
with duplicate names.

Thus I do not recommend changing the format of the name
that we have been exporting since cpuidle went
upstream 3 years ago.

thanks,
Len Brown, Intel Open Source Technology Center

