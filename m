Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271Ab2ILO0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:26:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:13830 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759206Ab2ILO0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:26:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,410,1344236400"; 
   d="scan'208";a="144219398"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Introduce function to report unsupported syscall attribute flags
References: <1347447685-28513-1-git-send-email-robert.richter@amd.com>
	<1347448843.15764.3.camel@twins>
Date: Wed, 12 Sep 2012 07:26:38 -0700
In-Reply-To: <1347448843.15764.3.camel@twins> (Peter Zijlstra's message of
	"Wed, 12 Sep 2012 13:20:43 +0200")
Message-ID: <m2oblbz59d.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, 2012-09-12 at 13:01 +0200, Robert Richter wrote:
>> +       if (notsup)
>> +               pr_warn("perf: unsupported attribute flags: %016llx\n", notsup); 
>
> This is a dmesg DoS..
>
> I'm also not sure dmesg is the right way.. could we not somehow change
> the attrs to provide better diagnostic?

Have a output argument for a string, that is then printed by the user tool?

I agree it's a problem today, i usually have to resort to ftrace to
figure out what'swrong.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
