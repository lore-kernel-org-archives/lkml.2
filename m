Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1JQPWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:22:33 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:4801 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab1JQPWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:22:32 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz98dKzz1202hzzz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LT7UP1-01-G80-02
X-M-MSG: 
Date: Mon, 17 Oct 2011 17:22:03 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 0/5] oprofile: Updates and fixes for timer modes
Message-ID: <20111017152203.GE24346@erda.amd.com>
References: <1318861624-715-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1318861624-715-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologize the corrupted subject line in my emails, these are the
correct patch titles:

On 17.10.11 16:26:59, Robert Richter wrote:
> Robert Richter (5):
>       oprofile, x86: Add kernel parameter oprofile.cpu_type=timer
>       oprofile: Fix crash when unloading module (hr timer mode)
>       oprofile, x86: Fix crash when unloading module (nmi timer mode)
>       oprofile: Remove exit function for timer mode
>       oprofile, x86: Reimplement nmi timer mode using perf event

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

