Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab2DIRL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:11:56 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62804 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2DIRLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:11:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120406114812.GE30425@liondog.tnic>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
	<1333666086-6517-5-git-send-email-fweisbec@gmail.com>
	<20120406114812.GE30425@liondog.tnic>
Date: Mon, 9 Apr 2012 19:11:55 +0200
Message-ID: <CAFTL4hw5POeCgebiL7ndqWma9hEvJEPtNWmEmPTofiTa_wKBmA@mail.gmail.com>
Subject: Re: [PATCH 04/15] events: Update tools/lib/traceevent to work with perf
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/6 Borislav Petkov <bp@alien8.de>:
> On Fri, Apr 06, 2012 at 12:47:55AM +0200, Frederic Weisbecker wrote:
>> From: Steven Rostedt <srostedt@redhat.com>
>>
>> Some of the util functions of libtraceevent.a conflict with perf,
>> such as die(), warning() and others. Move them into event-util.h
>
> Minor: judging by the patch below, you mean "event-utils.h" here.

Right, will fix the changelog.
