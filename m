Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab1AQEUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 23:20:25 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:62413 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab1AQEUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 23:20:23 -0500
Date: Sun, 16 Jan 2011 23:20:15 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH] ACPI: Fix memory leak in
 acpi_ev_asynch_execute_gpe_method().
In-reply-to: <alpine.LNX.2.00.1101162033531.13377@swampdragon.chaosbits.net>
Message-id: <alpine.LFD.2.02.1101162313220.3244@x980>
References: <alpine.LNX.2.00.1101162033531.13377@swampdragon.chaosbits.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like this bug was added by 
5a284cd75d635e3c5db0210dc9a9a44c6839f460
(ACPICA: Fix local variable mess in acpi_ev_asynch_execute_gpe_method).

The good news is that it is new in 2.6.38-merge
Also, I doubt that these error cases actually
occur in any significant frequency in practice.

Thanks for the find.

Len Brown, Intel Open Source Technology Center

