Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1LTBhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:37:32 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:43502
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753898Ab1LTBh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:37:29 -0500
X-SpamScore: -16
X-BigFish: VPS-16(zzbb2dI15bfK103dK1432N98dKzz1202hzzz2fh668h839h946h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4EEFE6B7.2010101@am.sony.com>
Date: Mon, 19 Dec 2011 17:36:55 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>
Subject: Re: [RFC PATCH v2 0/6] ARM: Remove the __ARCH_WANT_INTERRUPTS_ON_CTXSW
 definition
References: <1324306673-4282-1-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1324306673-4282-1-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/11 06:57, Catalin Marinas wrote:
> Hi,
> 
> This is version 2 of the set of patches for removing
> __ARCH_WANT_INTERRUPTS_ON_CTXSW on ARM. The series was updated to allow
> for the pgd switch not to be deferred if switch_mm() is called with
> interrupts enabled. This is required for cases where switch_mm() is
> called directly (currently from use_mm() and idle_task_exit()) without a
> corresponding finish_arch_post_lock_switch() call. The original changes
> to activate_mm() were also reverted since switch_mm() can do the actual
> pgd switch when the interrupts are enabled.
> 
> If there are no objections, I'd like to push the series to -next to get
> more exposure (the patches are aimed for 3.4-rc1 unless other issues are
> found in the meantime).

Version 2 looks good to me.  Thanks!

-Frank

