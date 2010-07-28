Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab0G1S7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:59:14 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:36034 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0G1S7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:59:10 -0400
Date: Wed, 28 Jul 2010 14:58:51 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Yu, Luming" <luming.yu@intel.com>,
        Philip Langdale <philipl@overt.org>, Jeff Garrett <jeff@jgarrett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "venki@google.com" <venki@google.com>
Subject: Re: [PATCH] ACPI: create "processor.bm_check_disable" boot param
In-reply-to: <20100727112841.GC7813@basil.fritz.box>
Message-id: <alpine.LFD.2.00.1007281456350.26093@localhost.localdomain>
References: <20100525124325.GC7876@srcf.ucam.org>
 <alpine.LFD.2.00.1005251114420.4114@localhost.localdomain>
 <20100525185507.GA15997@srcf.ucam.org>
 <alpine.LFD.2.00.1007211729550.409@localhost.localdomain>
 <20100722074750.GA22520@one.firstfloor.org>
 <alpine.LFD.2.00.1007221153120.3164@localhost.localdomain>
 <alpine.LFD.2.00.1007221720270.7970@localhost.localdomain>
 <alpine.LFD.2.00.1007221739260.7970@localhost.localdomain>
 <87k4oiiu3x.fsf@basil.nowhere.org>
 <alpine.LFD.2.00.1007262007550.5292@localhost.localdomain>
 <20100727112841.GC7813@basil.fritz.box>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 27 Jul 2010, Andi Kleen wrote:

> > > This needs to be also documented in Documentation/kernel-parameters.txt
> > 
> > I thought about that and decided against it.
> > While we do document some driver specific modparams
> > in kernel-parameters.txt, I do not expect this one to
> > be used that often -- mostly for diagnosis of BIOS bugs.
> > I know of two machines that need it,
> > and both of those machines have a BIOS update
> > or a BIOS update in progress that make it unnecessary.
> 
> I think even obscure parameters should be documented.

Where?

kernel-parameters.txt seems to be mostly about core kernel parameters.
While there are some key driver parameters in there, they
appear to be the exception.

-Len

