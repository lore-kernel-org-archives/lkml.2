Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037Ab1CXQCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:02:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:8098 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933729Ab1CXQCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:02:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,237,1299484800"; 
   d="scan'208";a="901319206"
From: Andi Kleen <andi@firstfloor.org>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support (v2)
References: <alpine.LFD.2.02.1103232321070.3848@x980>
	<20110324154505.934a56a0.sfr@canb.auug.org.au>
	<alpine.LFD.2.02.1103240336590.4529@x980>
	<alpine.LFD.2.02.1103240414450.4529@x980>
	<alpine.LFD.2.02.1103240430110.16085@x980>
Date: Thu, 24 Mar 2011 09:01:17 -0700
In-Reply-To: <alpine.LFD.2.02.1103240430110.16085@x980> (Len Brown's message
	of "Thu, 24 Mar 2011 04:31:48 -0400 (EDT)")
Message-ID: <m2y644tsmq.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:

> Microsoft was able to delete APM from Windows in 2006
> with the release of Windows Vista.  5 years later it seems
> quite safe that the latest Linux kernel can also.
>
> The vintage APM laptops have become difficult to find,
> making changes in this area difficult to test.

One other use-case even on non laptops was powering off the system.
I know my desktops used to need that.

Would it make sense to retain that path? 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
