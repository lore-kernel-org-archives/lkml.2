Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab2FTMXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:23:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40433 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab2FTMXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:23:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120619113434.GB6560@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
	<1317336490-19437-8-git-send-email-acme@infradead.org>
	<20120618145108.GG5046@erda.amd.com>
	<87zk80giag.fsf@sejong.aot.lge.com>
	<CABPqkBQA+CDxzp_g2Lu=Uoet5oqOq5E_1eiATGfoX=d7xEO49g@mail.gmail.com>
	<20120619113434.GB6560@infradead.org>
Date: Wed, 20 Jun 2012 14:23:21 +0200
Message-ID: <CABPqkBTb+_WbhDcThrghBiEzTmgSBLJg=yaD_db04mms=yec0A@mail.gmail.com>
Subject: Re: [PATCH] perf stat: Fix default logfd to use stderr
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jim Cromie <jim.cromie@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I see it now.
thanks.
the only one left at this point is the pipe mode meta-data patch
to add header in pipe mode.

On Tue, Jun 19, 2012 at 1:34 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Tue, Jun 19, 2012 at 08:09:31AM +0200, Stephane Eranian escreveu:
>> On Tue, Jun 19, 2012 at 4:13 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>> > On Mon, 18 Jun 2012 16:51:08 +0200, Robert Richter wrote:
>> >> With certain shell redirections this (56f3bae) fails with a log fd
>> >> setup failure. Fix below.
>
>> > It looks somewhat related to Stephane's patch. Can you we check it too?
>
>> > http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/04232.html
>
>> Yes, my patch is needed and it was posted over a month ago now.....
>> Arnaldo, please apply my patch.
>
> It was applied a week ago, was merged already by Ingo, should go to
> Linus soon:
>
> http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commit;h=fc3e4d077d5c7a7bc1ad5bc143895b4e070e5a8b
>
> - Arnaldo
