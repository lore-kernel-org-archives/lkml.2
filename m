Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab0HOCdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 22:33:41 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:43910 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864Ab0HOCdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 22:33:39 -0400
Date: Sat, 14 Aug 2010 22:33:31 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ike Panhc <ike.pan@canonical.com>
Cc: David Woodhouse <dwmw2@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Corentin Chary <corentincj@iksaif.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Thomas Renninger <trenn@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ideapad-laptop: add new driver
In-reply-to: <4C6605DF.8080605@canonical.com>
Message-id: <alpine.LFD.2.00.1008142229540.2294@localhost.localdomain>
References: <1281672482-10909-1-git-send-email-ike.pan@canonical.com>
 <1281690893.23680.475.camel@localhost>  <4C650FFB.7090602@canonical.com>
 <1281692078.23680.487.camel@localhost> <4C6605DF.8080605@canonical.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you merge the drivers, I'd sure prefer the name "ideapad-laptop"
over "ideapad-acpi".

While the maintainerless "toshiba-acpi" driver was a pioneer,
and thinkpad-acpi feared installed-base confusion when considering
a name change, we tend to reserve the "acpi" in drivers for things
that supply ACPI, rather than simply use ACPI.

Also, you may find that the platform driver ends up doing
more for the laptop than just using what is behind its
platform-specific ACPI extension.

thanks,
Len Brown, Intel Open Source Technology Center

