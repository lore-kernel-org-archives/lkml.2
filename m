Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2LZRjC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 12:39:02 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:41090 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2LZRi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 12:38:59 -0500
MIME-Version: 1.0
In-Reply-To: <87zk11s8j3.fsf@sejong.aot.lge.com>
References: <50D77528.6050003@googlemail.com>
	<87zk11s8j3.fsf@sejong.aot.lge.com>
Date: Wed, 26 Dec 2012 18:38:58 +0100
Message-ID: <CABPqkBTS57_KeEVw76M0_XmZONFvRZX9a9jOeddjTGJKTwbkNw@mail.gmail.com>
Subject: Re: Segfault in perf tool
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Stefan Beller <stefanbeller@googlemail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul Mackerras (supporter:PERFORMANCE EVENT...)" <paulus@samba.org>,
        "Ingo Molnar (supporter:PERFORMANCE EVENT...,commit_signer:2/9=22%)" 
	<mingo@redhat.com>,
        "Arnaldo Carvalho de Melo (supporter:PERFORMANCE EVENT... 
	,commit_signer:7/9=78%)" <acme@ghostprotocols.net>,
        "Anton Blanchard (commit_signer:1/9=11%)" <anton@samba.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 6:10 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi Stefan,
>
> On Sun, 23 Dec 2012 22:18:32 +0100, Stefan Beller wrote:
>> Hi,
>>
>> I get segmentation faults when running one of these commands:
>> perf report -g --sort symbol_to
>> perf report -g --sort symbol_from
>> perf report -g --sort dso_from
>> perf report -g --sort dso_to
>
> Those sort keys are only applicable for branch filtered perf.data file
> (i.e. recorded with -j or -b option) and should not be used for others.

That's true. Should print an error and not segfault.

> I'll work on the fix soon.
>
Thanks.
