Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab1LSJJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 04:09:35 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:38339 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1LSJJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 04:09:32 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz98dKzz1202hzzz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWG1FM-02-098-02
X-M-MSG: 
Date: Mon, 19 Dec 2011 10:09:23 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Benjamin Block <bebl@mageta.org>, Hans Rosenfeld <hans.rosenfeld@amd.com>,
        <hpa@zytor.com>, <tglx@linutronix.de>, <suresh.b.siddha@intel.com>,
        <eranian@google.com>, <brgerst@gmail.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111219090923.GB16765@erda.amd.com>
References: <20111216160757.GL665@escobedo.osrc.amd.com>
 <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com>
 <1324051943-21112-4-git-send-email-hans.rosenfeld@amd.com>
 <20111218080443.GB4144@elte.hu>
 <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de>
 <20111218234309.GA12958@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111218234309.GA12958@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.12.11 00:43:10, Ingo Molnar wrote:
> So the question becomes, how well is it integrated: can
> perf 'record -a + perf report', or 'perf top' use LWP,
> to do system-wide precise [user-space] profiling and such?

There is only self-monitoring of a process possible, no kernel and
system-wide profiling. This is because we can not allocate memory
regions in the kernel for a thread other than the current. This would
require a complete rework of mm code.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

