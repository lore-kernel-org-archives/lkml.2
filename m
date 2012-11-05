Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab2KEPEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:04:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62962 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab2KEPEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:04:47 -0500
Message-ID: <5097D58A.7030901@gmail.com>
Date: Mon, 05 Nov 2012 08:04:42 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Hannes Frederic Sowa <hannes@mailcolloid.de>
CC: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, ananth@in.ibm.com, fweisbec@gmail.com,
        suzuki@in.ibm.com, tglx@linutronix.de
Subject: Re: [tip:perf/core] perf tools: Remove the node from rblist in strlist__remove
References: <20120829055840.7802.1459.stgit@suzukikp.in.ibm.com> <tip-4592281403e74dc4401d5803ec9948d43bbee7ae@git.kernel.org> <CAMEyesC9H+k-Ypd6F6wLGTWXJzjQ3Va8jQ0ANJzk6gf3FUMOtw@mail.gmail.com>
In-Reply-To: <CAMEyesC9H+k-Ypd6F6wLGTWXJzjQ3Va8jQ0ANJzk6gf3FUMOtw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/3/12 2:07 PM, Hannes Frederic Sowa wrote:
> On Fri, Sep 7, 2012 at 8:04 AM, tip-bot for Suzuki K. Poulose
> <suzuki@in.ibm.com> wrote:
>> Reported-by: Ananth N. Mavinakayanahalli <ananth@in.ibm.com>
>> Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
>> Acked-by: David Ahern <dsahern@gmail.com>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: David Ahern <dsahern@gmail.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Link: http://lkml.kernel.org/r/20120829055840.7802.1459.stgit@suzukikp.in.ibm.com
>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> Shouldn't this patch go to the -stable queues, too?
>

yes for 3.5

David
