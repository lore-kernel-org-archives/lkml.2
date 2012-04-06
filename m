Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab2DFAI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:08:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63815 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab2DFAI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:08:28 -0400
Message-ID: <4F7E33F6.7050309@gmail.com>
Date: Thu, 05 Apr 2012 18:08:22 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 02/15] tools/events: Add files to create libtraceevent.a
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com> <1333666086-6517-3-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1333666086-6517-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/12 4:47 PM, Frederic Weisbecker wrote:
> From: Steven Rostedt<srostedt@redhat.com>
>
> Copy over the files from trace-cmd to the Linux tools directory
> such that applications like perf and latencytrace can use the
> more advanced parsing code.
>
> Because some of the file names of perf conflict with trace-cmd file
> names, the trace-cmd files have been renamed as follows:
>
>   parse-events.c ==>  event-parse.c
>   parse-events.h ==>  event-parse.h
>   utils.h        ==>  event-utils.h
>
> The files have been updated to handle the changes to the header files
> but other than that, they are identical to what was in the trace-cmd
> repository. The history of these files, including authorship is
> available at the git repo:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
>
> The Makefile was also copied over, but most of it was removed to
> focus on the parse-events code first. The parts of the Makefile for
> the plugins have also been removed, but will be added back when the
> plugin code is copied over as well. But that may be in its own
> separate directory.


I found that this lib needs to be an .so to work with trace-cmd's plugins.

David
