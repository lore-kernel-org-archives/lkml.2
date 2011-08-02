Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1HBWDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:03:24 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:47807 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab1HBWDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:03:17 -0400
Date: Tue, 02 Aug 2011 18:03:07 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [BUGFIX] ACPI, APEI, EINJ Param support is disabled by default
In-reply-to: <1311149369-20624-1-git-send-email-ying.huang@intel.com>
Message-id: <alpine.LFD.2.02.1108021802330.25237@x980>
References: <1311149369-20624-1-git-send-email-ying.huang@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied as-is to the apei branch.

please minde the checkpatch 80-column thing.

thanks,
Len Brown, Intel Open Source Technology Center

