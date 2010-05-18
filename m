Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0ERJgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 05:36:32 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:26637 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab0ERJg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 05:36:29 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lzz1202hz4fhz6d525hz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L2LZZ5-02-8RY-02
X-M-MSG: 
Date: Tue, 18 May 2010 11:35:35 +0200
From: Robert Richter <robert.richter@amd.com>
To: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "eranian@google.com" <eranian@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "acme@redhat.com" <acme@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mhiramat@redhat.com" <mhiramat@redhat.com>,
       "mingo@elte.hu" <mingo@elte.hu>
CC: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:perf/core] perf probe: Don't compile CFI related code if
 elfutils is old
Message-ID: <20100518093535.GF21799@erda.amd.com>
References: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
 <tip-7752f1b096e13991f20b59fd11ba73da3809d93c@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <tip-7752f1b096e13991f20b59fd11ba73da3809d93c@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.05.10 21:57:38, tip-bot for Masami Hiramatsu wrote:
> Commit-ID:  7752f1b096e13991f20b59fd11ba73da3809d93c
> Gitweb:     http://git.kernel.org/tip/7752f1b096e13991f20b59fd11ba73da3809d93c
> Author:     Masami Hiramatsu <mhiramat@redhat.com>
> AuthorDate: Mon, 10 May 2010 13:12:07 -0400
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Mon, 17 May 2010 22:13:51 -0300
> 
> perf probe: Don't compile CFI related code if elfutils is old
> 
> Check elfutils version, and if it is old don't compile CFI analysis code. This
> allows to compile perf with old elfutils.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Tested-by: Stephane Eranian <eranian@google.com>
> Reported-by: Robert Richter <robert.richter@amd.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> LKML-Reference: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---

I think this patch is not needed as we came up with an alternative
solution with commit:

 6b3c4ef perf probe: Check older elfutils and set NO_DWARF

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

