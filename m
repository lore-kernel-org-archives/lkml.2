Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798Ab2FGKgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:36:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62222 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab2FGKgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:36:24 -0400
MIME-Version: 1.0
In-Reply-To: <1339064963.23343.16.camel@twins>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
	<1337801535-12865-2-git-send-email-jolsa@redhat.com>
	<1337852636.9783.89.camel@laptop>
	<20120607094624.GB19842@somewhere.redhat.com>
	<1339064963.23343.16.camel@twins>
Date: Thu, 7 Jun 2012 12:36:22 +0200
Message-ID: <CABPqkBTCEaDy9in75_=uu9U_4w5=wgyKDaAZ-jYHnbj-6vs9Sw@mail.gmail.com>
Subject: Re: [PATCH 01/16] perf: Unified API to record selective sets of arch registers
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 12:29 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-06-07 at 11:46 +0200, Frederic Weisbecker wrote:
>>
>> Do you think that compat regs are always a subset of native regs in all
>> archs as in x86? Sounds logic but I'm asking just in case. If so then yeah
>> this should work.
>
> I can't answer this authoritatively but it would seem strange if this
> were not the case. But even if it were so, you could always frob both
> sets in a single space such that the shared registers overlap etc.

Agreed.
