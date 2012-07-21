Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2GUAU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 20:20:58 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50381 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab2GUAU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 20:20:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLGFE8QSS06Wj+nhOS8XCpGoMH4bOqwvPi736uBrgJa3uQ@mail.gmail.com>
References: <1342712558-8185-1-git-send-email-namhyung@kernel.org>
 <1342712558-8185-6-git-send-email-namhyung@kernel.org> <CAOJsxLGFE8QSS06Wj+nhOS8XCpGoMH4bOqwvPi736uBrgJa3uQ@mail.gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Sat, 21 Jul 2012 09:20:36 +0900
X-Google-Sender-Auth: dDpdEa1pyV9_WuL9Pq5XtpvUiW8
Message-ID: <CAM9d7ci2W+kDCSpQkTdNHu2GUs6rp=VLjs9M9vCO4uAHsVCxzw@mail.gmail.com>
Subject: Re: [PATCH 5/5] perf gtk/browser: Use hist_period_print functions
To: Pekka Enberg <penberg@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 10:43 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Thu, Jul 19, 2012 at 6:42 PM, Namhyung Kim <namhyung@kernel.org> wrote:
>> Now we can support color using pango markup with this change.
>>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>
> Can you please CC me on perf GTK patches?
>

Sorry, I'll do that in the future. :)


> [snip]
>
>> +#define HPP_COLOR_FN(_name, _field)                                            \
>
> Where does this "hpp" naming convention come from? What does it stand for?

It's the hist_period_print as the subject said, though I'm not happy
with the name.
I'm open to a better name suggestion.

Thanks,
Namhyung
