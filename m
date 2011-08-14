Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1HNCiJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 22:38:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:58283 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1HNCiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 22:38:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,368,1309762800"; 
   d="scan'208";a="38213335"
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
References: <20110812150304.GC16880@albatros> <4E45884B.8030303@zytor.com>
	<20110813062246.GC3851@albatros>
	<36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com>
Date: Sat, 13 Aug 2011 19:38:05 -0700
In-Reply-To: <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com>
	(H. Peter Anvin's message of "Sat, 13 Aug 2011 10:41:54 -0500")
Message-ID: <m2ei0olnua.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
>
> IA64 is totally different.  I'm extremely sceptical to this patch; it feels like putting code in a super-hot path to paper over a problem that has to be fixed anyway.

Sounds to me a better alternative would be more aggressive, pro-active
fuzzing of the compat calls.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
