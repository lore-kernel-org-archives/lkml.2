Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab0F3PSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:18:11 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:34005 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0F3PSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:18:09 -0400
Date: Wed, 30 Jun 2010 11:17:48 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, "clarkt@cnsp.com" <clarkt@cnsp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] kacpi_notify goes into an infinite loop (luckly it calls
 cond_resched)
In-reply-to: <1277905208.24800.21.camel@gandalf.stny.rr.com>
Message-id: <alpine.LFD.2.00.1006301115370.3989@localhost.localdomain>
References: <1275094882.22648.607.camel@gandalf.stny.rr.com>
 <1275274670.9119.4419.camel@rzhang1-desktop>
 <1277905208.24800.21.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> /sys/firmware/acpi/interrupts/sci_not:       1

This means that acpi_irq was invoked and could not find a cause for the 
interrupt.

Does /proc/interrupts show that the acpi interrupt shares and IRQ
with another device, or is it alone?

thanks,
Len Brown, Intel Open Source Technology Center

