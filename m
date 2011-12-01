Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1LADO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:14:26 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:36291
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289Ab1LADOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:14:25 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2dK1432N98dKzz1202hzz8275bhz2fh668h839h946h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4ED6F0FD.1080702@am.sony.com>
Date: Wed, 30 Nov 2011 19:14:05 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 0/6] ARM: Remove the __ARCH_WANT_INTERRUPTS_ON_CTXSW
 definition
References: <1322569352-23584-1-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1322569352-23584-1-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/11 04:22, Catalin Marinas wrote:
> Hi,
> 
> This set of patches removes the use of __ARCH_WANT_INTERRUPTS_ON_CTXSW
> on ARM.

All 6 patches:

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>

