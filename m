Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab2JSIqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:46:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab2JSIqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:46:53 -0400
Date: Fri, 19 Oct 2012 10:46:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>, David Ahern <dsahern@gmail.com>
Subject: Re: [BUG] perf list: --help option not implemented
Message-ID: <20121019084636.GB980@krava.brq.redhat.com>
References: <CABPqkBS9Wm2c=fnaQzKycXnuqRtAocAZ4qQ7ToAaaVDQbtVoyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS9Wm2c=fnaQzKycXnuqRtAocAZ4qQ7ToAaaVDQbtVoyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 10:27:35AM +0200, Stephane Eranian wrote:
> Jiri,
> 
> When I run perf list, I see:
> 
> $ perf list
>   ..
>   rNNN                                               [Raw hardware
> event descriptor]
>   cpu/t1=v1[,t2=v2,t3 ...]/modifier                  [Raw hardware
> event descriptor]
>    (see 'perf list --help' on how to encode it)
> 
> But:
> $ perf list --help
> $
> 
> Shows nothing. Looked at the code and I don't see where you handle the --help
> option. You need some help to figure out what the modifiers are.
> 
> Am I missing something here?

nope, it's not working.. added on my todo list ;-)

thanks,
jirka
