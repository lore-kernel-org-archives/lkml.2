Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2DBXyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 19:54:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:4636 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab2DBXyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 19:54:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="136831224"
Date: Mon, 2 Apr 2012 16:54:12 -0700
From: Andi Kleen <ak@linux.intel.com>
To: =?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: Re: [v3.4-rc1] ACPI regression bisected
Message-ID: <20120402235412.GD16303@tassilo.jf.intel.com>
References: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  ACPI: Added _OSI(Processor Aggregator Device)
>  ACPI: EC: EC description table is found, configuring boot EC
> 
> Comparing this with the displays of kernel v3.3 the next expected
> outputs would be:
> 
>  ACPI: Interpreter enabled
>  ACPI: (supports S0 S5)
> 
> 
> I bisected the problem to commit:
> 6fe0d0628245fdcd6fad8b837c81e8f7ebc3364d  "ACPI: Make ACPI interrupt threaded"

Hmm, that's odd. It should not really change any semantics. I assume you double
checked you hit the right commit?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
