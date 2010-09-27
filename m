Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556Ab0I0PKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:10:13 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:28640 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab0I0PKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:10:12 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Thomas Renninger <trenn@suse.de>
Subject: Re: Dynamic Debug module.ddebug fake param enhancements V4
Date: Mon, 27 Sep 2010 09:09:18 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, jbaron@redhat.com
References: <20100920184441.GA2915@redhat.com> <201009240856.17411.bjorn.helgaas@hp.com> <201009271025.47558.trenn@suse.de>
In-Reply-To: <201009271025.47558.trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009270909.18490.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 27, 2010 02:25:46 am Thomas Renninger wrote:

> What do you think (dev_dbg vs printk(KERN_DEBUG...)?

Well, 99% of the time, what I want is simply the resource usage of all
the devices in the system.  Currently, a dmesg log gives me that for
PCI devices.  I plan to change PNP so the dmesg log will also contain
that for PNP devices.  That's simple and requires no user action at all
and no extra boots.

The times when we need more extensive debugging are rare enough that
I'm not sure it's worth keeping them compiled into the kernel, even
if they are turned off by default (I understand the tradeoff from
a distro point of view might be different).

With the exception of the ones in pnp/resource.c that I want to convert
to dev_printk(KERN_DEBUG), I think all the pnp_dbg() uses are things
I used during PNP development and haven't ever needed since.

Bjorn
