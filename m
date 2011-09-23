Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab1IWJRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 05:17:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39556 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab1IWJRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 05:17:21 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBSpqNWJVhRh4bKRK5PGcCdZhzsJzyeQ53Mh4_7fVUm+wg@mail.gmail.com>
References: <20110922123128.GA9761@quad>
	<CAOJsxLFDaYxevsH8UYEeZJrz7HCZSg89_XTaXP=hPTTG2HH9=w@mail.gmail.com>
	<CABPqkBQSBKS+bnLhStzV4PTrE+Qrb1XyeR5FEyn4d+NFZrhuOQ@mail.gmail.com>
	<CAOJsxLE1L1ffZmuF+2+vYZMTXyvq00pOcP1xvGJuW0TqxQskrA@mail.gmail.com>
	<CABPqkBSpqNWJVhRh4bKRK5PGcCdZhzsJzyeQ53Mh4_7fVUm+wg@mail.gmail.com>
Date: Fri, 23 Sep 2011 12:17:20 +0300
X-Google-Sender-Auth: REw52lrfmmjNTdH4QiH0x4vs0LQ
Message-ID: <CAOJsxLE_kF2O6FrG7bLHtQKFV_D=PB77jP+aWBp1UERKzO4qng@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v5)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu, dsahern@gmail.com, robert.richter@amd.com,
        ak@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 10:03 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>> Well, sure but it blocks rest of the interesting information too. It seems to me
>> that the CPU information could be truncated to some sane limit by default and
>> introduce a command line option for users that really want to see all of it.

On Fri, Sep 23, 2011 at 12:04 PM, Stephane Eranian <eranian@google.com> wrote:
> Ok, so here is a proposal:
> - reorder the info so one liners appear first
> - display the "truncated" info by default (no option)
> - truncated: numa topo, cpu topo, stop after 4 cpus/nodes, print msg
> to hint at -I option
> - use -I to print the extended header info report
>
> That way we do no introduce two options just for the header information.
>
> How about that instead?

Yup, makes sense to me. Up to perf maintainers, of course.

                         Pekka
