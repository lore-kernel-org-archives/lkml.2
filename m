Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab2H0Prz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:47:55 -0400
Received: from mail.x86-64.org ([217.9.48.20]:60149 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab2H0Pry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:47:54 -0400
Date: Mon, 27 Aug 2012 17:47:41 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, andi@firstfloor.org, gong.chen@linux.intel.com,
        ananth@in.ibm.com, masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lcm@us.ibm.com, mingo@redhat.com,
        tglx@linutronix.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/mce: Pack boolean MCE boot flags into a structure
Message-ID: <20120827154741.GI27979@aftab.osrc.amd.com>
References: <20120827112503.10313.62594.stgit@localhost.localdomain>
 <20120827143619.GE27979@aftab.osrc.amd.com>
 <503B93D2.7090702@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503B93D2.7090702@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 09:05:46PM +0530, Naveen N. Rao wrote:
> >>+
> >>+extern struct mce_boot_flags mce_boot_flags;
> >
> >Why do we need that extern thing?
> 
> So that this is visible across mce.c and mce_intel.c?

Ok. But if you move the struct to mce-internal.h and since both .c files
include it, we shouldn't need that extern, right?

I think that'll be the most optimal placement for now.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
