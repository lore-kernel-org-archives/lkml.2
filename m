Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2FSGJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:09:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41704 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab2FSGJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:09:33 -0400
MIME-Version: 1.0
In-Reply-To: <87zk80giag.fsf@sejong.aot.lge.com>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
	<1317336490-19437-8-git-send-email-acme@infradead.org>
	<20120618145108.GG5046@erda.amd.com>
	<87zk80giag.fsf@sejong.aot.lge.com>
Date: Tue, 19 Jun 2012 08:09:31 +0200
Message-ID: <CABPqkBQA+CDxzp_g2Lu=Uoet5oqOq5E_1eiATGfoX=d7xEO49g@mail.gmail.com>
Subject: Re: [PATCH] perf stat: Fix default logfd to use stderr
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jim Cromie <jim.cromie@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 4:13 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi, Robert
>
> On Mon, 18 Jun 2012 16:51:08 +0200, Robert Richter wrote:
>> On 29.09.11 18:48:01, Arnaldo Carvalho de Melo wrote:
>>> From: Jim Cromie <jim.cromie@gmail.com>
>>>
>>> This perf stat option emulates valgrind's --log-fd option, allowing the
>>> user to send perf results elsewhere, and leaving stderr for use by the
>>> program under test.  This complements --output file option, and is
>>> mutually exclusive with it.
>>>
>>>    3>results  perf stat --log-fd 3          -- $cmd
>>>    3>>results perf stat --log-fd 3 --append -- $cmd
>>>
>>> The perl distro's make test.valgrind target uses valgrind's --log-fd
>>> option, I've adapted it to invoke perf also, and tested this patch
>>> there.
>>>
>>> Link: http://lkml.kernel.org/r/1315437244-3788-2-git-send-email-jim.cromie@gmail.com
>>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>>> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
>>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>>
>> With certain shell redirections this (56f3bae) fails with a log fd
>> setup failure. Fix below.
>>
>
> It looks somewhat related to Stephane's patch. Can you we check it too?
>
> http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/04232.html
>
Yes, my patch is needed and it was posted over a month ago now.....
Arnaldo, please apply my patch.

> Thanks,
> Namhyung
