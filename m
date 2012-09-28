Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab2I1Ft6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 01:49:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37177 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab2I1Ft5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 01:49:57 -0400
Message-ID: <50653A7A.1020806@zytor.com>
Date: Thu, 27 Sep 2012 22:49:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Distinguish TLB shootdown interrupts from other
 functions call interrupts
References: <50611D82.4010702@intel.com> <20120926021128.22212.20440.stgit@hpxw> <5063F9FD.8050002@intel.com>
In-Reply-To: <5063F9FD.8050002@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 12:02 AM, Alex Shi wrote:
>
> Peter:
>
> Maybe the patch doesn't looks perfect for this issue.
> So I am wondering if the following patch is better, if we don't care the irq_tlb
> was counted again in irq_call?
>

Tomoki-san's patch looked sane to me, I should just apply it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

