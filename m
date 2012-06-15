Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2FOQQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 12:16:50 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:21820
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756304Ab2FOQQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 12:16:49 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIzz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5O2JR-01-DZM-02
X-M-MSG: 
Date: Fri, 15 Jun 2012 18:16:35 +0200
From: Robert Richter <robert.richter@amd.com>
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] oprofile: perf: use NR_CPUS instead or nr_cpumask_bits
 for static array
Message-ID: <20120615161635.GV1478@erda.amd.com>
References: <1339168564-30008-1-git-send-email-will.deacon@arm.com>
 <20120615154359.GE12031@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120615154359.GE12031@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.06.12 16:43:59, Will Deacon wrote:
> Given both the lack of feedback and the trivial nature of this patch would
> you be able to pick this up please? I'd rather not push it via the ARM tree
> as the change is under drivers/.

Will, I will apply it. Sorry for not responding earlier.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

