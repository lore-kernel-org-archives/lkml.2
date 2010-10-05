Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0JEFGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 01:06:39 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:56882 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab0JEFGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 01:06:38 -0400
Date: Tue, 05 Oct 2010 01:06:15 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
        linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3 boot
 hang
In-reply-to: <20100930222946.GB23084@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.1010050104450.23209@localhost.localdomain>
References: <alpine.LFD.2.00.1009242122390.8641@localhost.localdomain>
 <20100927135735.GA856@srcf.ucam.org>
 <alpine.LFD.2.00.1009301810380.7033@localhost.localdomain>
 <20100930222946.GB23084@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > we check (and clear) that bit only if the acpi tables
> > tell us to do so.
> 
> Do the tables tell us to do so on this platform?

In this configuration, yes, otherwise acpi_idle
would have failed in exactly the same way.

-Len Brown, Intel Open Source Technology Center

