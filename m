Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab2A3TA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 14:00:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab2A3TA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 14:00:26 -0500
Date: Mon, 30 Jan 2012 17:00:08 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        robert.richter@amd.com
Subject: Re: [PATCH] perf: fix broken perf inject -b
Message-ID: <20120130190008.GA5797@infradead.org>
References: <20120113144731.GA5458@quad> <20120113165315.GA24387@infradead.org> <CABPqkBTe1uqiLm02fijYE2bwF=rWWu=V0mjZQbEzW0TUKa4-+Q@mail.gmail.com> <CABPqkBS50jYOHepmAqOzGYY8m+4SCJQuhrMV2yLXRYfdFpE70g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBS50jYOHepmAqOzGYY8m+4SCJQuhrMV2yLXRYfdFpE70g@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 16, 2012 at 07:53:28PM +0100, Stephane Eranian escreveu:
> On Fri, Jan 13, 2012 at 5:54 PM, Stephane Eranian <eranian@google.com> wrote:
> > On Fri, Jan 13, 2012 at 5:53 PM, Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> >> Em Fri, Jan 13, 2012 at 03:47:31PM +0100, Stephane Eranian escreveu:
> >>> perf inject -b was broken. It would not inject any build_ids
> >>> into the stream. Furthermore, it would strip samples from the
> >>> stream.
<SNIP>
> >>> @@ -173,6 +178,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
> >>>               goto repipe;
> >>>       }
> >>> +     machine->pid = event->ip.pid;

> I noticed that this statement conflicts with perf buildid-list (which
> I am also fixing for pipe mode).

> I don't quite understand why, though.

Have you reached any conclusion about this problem? I haven't looked at
it in detail, could you please elaborate more?

- Arnaldo
