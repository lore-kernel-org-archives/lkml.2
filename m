Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab2LDQCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 11:02:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46474 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab2LDQCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 11:02:00 -0500
Date: Tue, 4 Dec 2012 17:01:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 v8] AMD64 EDAC: Fix type usage in NB IDs and memory
 ranges
Message-ID: <20121204160156.GH4369@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Steffen Persvold <sp@numascale.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1354265060-22956-1-git-send-email-daniel@numascale-asia.com>
 <1354265060-22956-2-git-send-email-daniel@numascale-asia.com>
 <20121130171749.GB23034@liondog.tnic>
 <50BDC140.8060004@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50BDC140.8060004@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 05:24:16PM +0800, Daniel J Blueman wrote:
> It works well on fam10h and fam15h boxes, with and without Numaconnect.

Good, thanks for testing.

I will send it upstream after the upcoming merge window closes since it
is too late for this one now and I wouldn't want to rush it if it is not
necessary to do so and it hasn't seen enough testing in linux-next and
-tip trees. Which means that it will end up in 3.9; I hope that is OK
with you guys.

Thanks.

-- 
Regards/Gruss,
    Boris.
