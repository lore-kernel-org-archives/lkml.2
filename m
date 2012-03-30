Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab2C3HZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 03:25:25 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:10884
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755342Ab2C3HZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 03:25:19 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz98dKzz1202hzz8275dh5eeeKz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1OSM1-01-GPA-02
X-M-MSG: 
Date: Fri, 30 Mar 2012 09:25:08 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        <acme@redhat.com>, <mingo@elte.hu>, <paulus@samba.org>,
        <cjashfor@linux.vnet.ibm.com>, <fweisbec@gmail.com>,
        <gorcunov@openvz.org>, <tzanussi@gmail.com>, <mhiramat@redhat.com>,
        <rostedt@goodmis.org>, <fche@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC 00/15] perf: Add backtrace post dwarf unwind
Message-ID: <20120330072507.GA16322@erda.amd.com>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
 <CABPqkBR7-JreB8c3Y1rNGpqdjeSN71qUkPrMxV-wjOSaTEx+vQ@mail.gmail.com>
 <1333065559.2960.8.camel@laptop>
 <CABPqkBQfy0CgSiDZ+KXd4fP9XxDxPTipyGbABZdEuTu4LkrsRQ@mail.gmail.com>
 <1333068279.2960.20.camel@laptop>
 <CABPqkBQbYs7JgGqfZD3ng6QMK0OpiVL=8gfyxn5aRgtYpPVjsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABPqkBQbYs7JgGqfZD3ng6QMK0OpiVL=8gfyxn5aRgtYpPVjsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.03.12 17:52:50, Stephane Eranian wrote:
> Unless I am mistaken, the x86_64 calling convention passes the first 6
> integer arguments in registers.

This is documented here:

 http://www.x86-64.org/documentation/abi.pdf
 3.2.3 Parameter Passing

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

