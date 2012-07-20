Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab2GTNnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:43:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52869 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2GTNnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:43:37 -0400
MIME-Version: 1.0
In-Reply-To: <1342712558-8185-6-git-send-email-namhyung@kernel.org>
References: <1342712558-8185-1-git-send-email-namhyung@kernel.org>
	<1342712558-8185-6-git-send-email-namhyung@kernel.org>
Date: Fri, 20 Jul 2012 16:43:36 +0300
X-Google-Sender-Auth: fO2dULCw5ZrrLOVNflDKafpXExo
Message-ID: <CAOJsxLGFE8QSS06Wj+nhOS8XCpGoMH4bOqwvPi736uBrgJa3uQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] perf gtk/browser: Use hist_period_print functions
From: Pekka Enberg <penberg@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 6:42 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> Now we can support color using pango markup with this change.
>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Can you please CC me on perf GTK patches?

[snip]

> +#define HPP_COLOR_FN(_name, _field)                                            \

Where does this "hpp" naming convention come from? What does it stand for?
