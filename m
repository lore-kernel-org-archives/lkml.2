Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab1DGCCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:02:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38756 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab1DGCCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=enwkB3/r2/m39ecOzgaP7ZQrvhgw24E3OHD2wk3sJ7CAMkgQXDOwTDE5RG1D0Tjf1q
         x0PcWBOJ0JNHZIRx2Htg==
MIME-Version: 1.0
In-Reply-To: <1300746846-28245-1-git-send-email-dhsharp@google.com>
References: <1300746846-28245-1-git-send-email-dhsharp@google.com>
From: David Sharp <dhsharp@google.com>
Date: Wed, 6 Apr 2011 19:01:40 -0700
Message-ID: <BANLkTimhAis_f5OXgzfMD7uKeX5qHYUsgA@mail.gmail.com>
Subject: Re: [PATCH perf 0/2] perf: trace-event-parse: support more operators
 and print formats
To: linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, any feedback on these patches? I think it's important that perf
and trace-cmd don't drift in the syntax they accept.

d#

On Mon, Mar 21, 2011 at 3:34 PM, David Sharp <dhsharp@google.com> wrote:
> These patches correspond to similar patches recently applied to trace-cmd
>
> [ Re-sending with more Cc's ]
>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Stephane Eranian <eranian@google.com>
>
>
> David Sharp (2):
>  perf: trace-event-parse: support additional operators: '!', '~',  and
>    '!='
>  perf: trace-event-parse: support printing short fields
>
>  tools/perf/util/trace-event-parse.c |   28 ++++++++++++++++++++++++++++
>  1 files changed, 28 insertions(+), 0 deletions(-)
>
> --
> 1.7.3.1
>
>
