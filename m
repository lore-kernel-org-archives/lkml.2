Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab2EXI7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:59:51 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34074 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2EXI7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:59:49 -0400
MIME-Version: 1.0
In-Reply-To: <87wr42q7s4.fsf@sejong.aot.lge.com>
References: <1337828525-1789-1-git-send-email-namhyung.kim@lge.com>
	<1337844471.9783.48.camel@laptop>
	<87wr42q7s4.fsf@sejong.aot.lge.com>
Date: Thu, 24 May 2012 10:59:47 +0200
Message-ID: <CABPqkBTcBG8nqsj0O9HGNxEJko+R30EwXQoHGguQ+PGWDsFRyA@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Make cycles:p working on SNB
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 10:53 AM, Namhyung Kim <namhyung.kim@lge.com> wrote:
> Hi, Peter
>
> On Thu, 24 May 2012 09:27:51 +0200, Peter Zijlstra wrote:
>> Also I'm thinking you're using SNB-EP (you didn't say) since regular SNB
>> has PEBS disabled as per (6a600a8b).
>>
>
> I don't actually have an idea whether it's a SNB-EP or regular
> one. ;-p Is Model 45 a SNB-EP?
>
Yes.

> namhyung@sejong:perf$ head /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 45
> model name      : Intel(R) Core(TM) i7-3930K CPU @ 3.20GHz
> stepping        : 7
> microcode       : 0x704
> cpu MHz         : 1200.000
> cache size      : 12288 KB
> physical id     : 0
>
>
> Thanks,
> Namhyung
