Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab2IMVDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 17:03:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52637 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab2IMVDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 17:03:49 -0400
Message-ID: <50524A31.1080403@gmail.com>
Date: Thu, 13 Sep 2012 15:03:45 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jovi Zhang <bookjovi@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: add /proc/perf_events file for dump perf events
 info
References: <CACV3sbLSzPoYYFJky=sFpca4L2gKdoOoEySn+mVHh1aphQLkyw@mail.gmail.com> <1341476877.7709.0.camel@twins> <CACV3sb+aadXJYu7_JUedCodgQmF8d1q7OxSVoz=vwfc+Ow_caA@mail.gmail.com> <CACV3sbLJpv2KSSkrRRDVuJ6xtJOSwCKaJfhO1wMF6DgAU9eCBw@mail.gmail.com>
In-Reply-To: <CACV3sbLJpv2KSSkrRRDVuJ6xtJOSwCKaJfhO1wMF6DgAU9eCBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/5/12 7:02 AM, Jovi Zhang wrote:
>   From 91fbcca37a2c9979083f4b9a6fa9c1875fc2886f Mon Sep 17 00:00:00 2001
> From: Jovi Zhang <bookjovi@gmail.com>
> Date: Fri, 6 Jul 2012 00:05:40 +0800
> Subject: [PATCH] perf: add /proc/perf_events file for dump perf events info
>
> This new /proc/perf_events file is used for real time dump all
> perf events info in whole system wide machine, this patch also add
> a new field perf_entry in struct perf_event, for connect to
> global list perf_events_list.

Applied your patch to see if sheds light on a problem. Saw this 
compiling the kernel:

kernel/events/proc_perf_events.c: In function ‘perf_events_proc_show’:
kernel/events/proc_perf_events.c:175:5: warning: format ‘%llu’ expects 
argument of type ‘long long unsigned int’, but argument 3 has type ‘long 
int’ [-Wformat]

David
