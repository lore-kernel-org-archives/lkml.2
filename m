Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab0GZHYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 03:24:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44314 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab0GZHYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 03:24:10 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Yu\, Luming" <luming.yu@intel.com>,
        Philip Langdale <philipl@overt.org>, Jeff Garrett <jeff@jgarrett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-acpi\@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "venki\@google.com" <venki@google.com>
Subject: Re: [PATCH] ACPI: create "processor.bm_check_disable" boot param
References: <20100427124703.GA16706@jgarrett.org>
	<alpine.LFD.2.00.1004301218280.2489@sony>
	<20100430174447.GA14889@srcf.ucam.org>
	<d7f2dd35a4361e5156079278543769a0@localhost>
	<alpine.LFD.2.00.1005250125590.20648@localhost.localdomain>
	<CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com>
	<20100525124325.GC7876@srcf.ucam.org>
	<alpine.LFD.2.00.1005251114420.4114@localhost.localdomain>
	<20100525185507.GA15997@srcf.ucam.org>
	<alpine.LFD.2.00.1007211729550.409@localhost.localdomain>
	<20100722074750.GA22520@one.firstfloor.org>
	<alpine.LFD.2.00.1007221153120.3164@localhost.localdomain>
	<alpine.LFD.2.00.1007221720270.7970@localhost.localdomain>
	<alpine.LFD.2.00.1007221739260.7970@localhost.localdomain>
Date: Mon, 26 Jul 2010 09:24:02 +0200
In-Reply-To: <alpine.LFD.2.00.1007221739260.7970@localhost.localdomain> (Len
	Brown's message of "Thu, 22 Jul 2010 17:40:02 -0400 (EDT)")
Message-ID: <87k4oiiu3x.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:
>
> Note also that an alternative for newer systems
> is to use the intel_idle driver, which always
> ignores BM_STS, relying Linux device drivers
> to register constraints explicitly via PM_QOS.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=15886

Thanks.  I don't fully understand why the check for this option
is in a different place than the register check in the earlier patch? 

This needs to be also documented in Documentation/kernel-parameters.txt

Other than that it looks good.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
