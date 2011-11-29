Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1K2U7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 15:59:33 -0500
Received: from mga14.intel.com ([143.182.124.37]:19010 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597Ab1K2U7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:59:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,593,1315206000"; 
   d="scan'208";a="80362108"
From: Andi Kleen <andi@firstfloor.org>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: cleanup some assembly entry points
References: <4ED4CEEA020000780006407D@nat28.tlf.novell.com>
Date: Tue, 29 Nov 2011 12:59:29 -0800
In-Reply-To: <4ED4CEEA020000780006407D@nat28.tlf.novell.com> (Jan Beulich's
	message of "Tue, 29 Nov 2011 11:24:10 +0000")
Message-ID: <m2mxbelk5q.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jan Beulich" <JBeulich@suse.com> writes:

> The compatibility mode ptregs entry points for one can make use of the
> GLOBAL() macro, and should be suitably aligned. Their shared
> continuation point (ia32_ptregs_common) otoh doesn't need to be global
> at all, but should continue to be properly aligned.

FWIW I reviewed all the patches and they look good to me
(except for the tricky THREAD_INFO patch, sorry)

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
