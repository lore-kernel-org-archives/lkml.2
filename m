Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931Ab1JGLyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:54:51 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43900 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1JGLyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:54:50 -0400
X-AuditID: b753bd60-a14abba0000019f4-0e-4e8ee887594d
X-AuditID: b753bd60-a14abba0000019f4-0e-4e8ee887594d
Message-ID: <4E8EE885.9040703@hitachi.com>
Date: Fri, 07 Oct 2011 20:54:45 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, robert.richter@amd.com, ravitillo@lbl.gov
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
References: <1317912555-9559-1-git-send-email-eranian@google.com>  <1317912555-9559-8-git-send-email-eranian@google.com>  <20111006153229.GJ14482@one.firstfloor.org>  <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com>  <CABPqkBReqBhFFKsLPfbzFHL7hs2hXSJ8tTZuP9D-2N2MGiB9Mw@mail.gmail.com>  <1317984122.31132.6.camel@twins>  <CABPqkBTxxS-vuAycDJO-aJNE4EpCLF8xyPtJ1Jzv26f15HJC8A@mail.gmail.com> <1317986519.31132.13.camel@twins>
In-Reply-To: <1317986519.31132.13.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/07 20:21), Peter Zijlstra wrote:
> On Fri, 2011-10-07 at 13:18 +0200, Peter Zijlstra wrote:
>>> Yeah, depending on the depth of the LBR. But then what happens, you
>>> decode an instruction that is not what was executed. 
>>
>> Right, and Andi's concern is that this might cause our instruction
>> decoder to blow up, or worse. 
> 
> That is, we have a fair confidence that its capable of correctly
> decoding correct streams, but I understood from Masami that they haven't
> actually tried feeding it crap.

OK, I'll do hardening it.

Thanks,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
