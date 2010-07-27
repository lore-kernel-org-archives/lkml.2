Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0G1OKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:10:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38848 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab0G1OJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:09:48 -0400
Date: Tue, 27 Jul 2010 13:28:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Len Brown <lenb@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "Yu, Luming" <luming.yu@intel.com>,
        Philip Langdale <philipl@overt.org>, Jeff Garrett <jeff@jgarrett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "venki@google.com" <venki@google.com>
Subject: Re: [PATCH] ACPI: create "processor.bm_check_disable" boot param
Message-ID: <20100727112841.GC7813@basil.fritz.box>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1007262007550.5292@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This needs to be also documented in Documentation/kernel-parameters.txt
> 
> I thought about that and decided against it.
> While we do document some driver specific modparams
> in kernel-parameters.txt, I do not expect this one to
> be used that often -- mostly for diagnosis of BIOS bugs.
> I know of two machines that need it,
> and both of those machines have a BIOS update
> or a BIOS update in progress that make it unnecessary.

I think even obscure parameters should be documented.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
