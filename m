Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388Ab2GEQsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:48:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42421 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2GEQsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:48:05 -0400
Message-ID: <4FF5C53F.30105@gmail.com>
Date: Thu, 05 Jul 2012 10:47:59 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf tool: save cmdline from user in file header vs what
 is passed to record
References: <1341288506-85207-1-git-send-email-dsahern@gmail.com> <CABPqkBSP9=QfU5SYfm0ys9FA6jro+az07zTMFnNAx+MMFr7+Vw@mail.gmail.com>
In-Reply-To: <CABPqkBSP9=QfU5SYfm0ys9FA6jro+az07zTMFnNAx+MMFr7+Vw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/5/12 9:48 AM, Stephane Eranian wrote:
> On Tue, Jul 3, 2012 at 6:08 AM, David Ahern <dsahern@gmail.com> wrote:
> Yes, you need to manually add the pfm_header__set_cmdline(). That begs

I take it you meant perf_header__set_cmdline, not pfm_header...

> the question
> as to whether or not it would not be better to move this call directly into
> the parse_option() function given that it must be done BEFORE parsing actually
> takes place.That way we would be sure all present and future commands would
> be covered.

Sure, I'll move it to parse_options.

David
