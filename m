Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab2AQQow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:44:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab2AQQov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:44:51 -0500
Message-ID: <4F15A570.8090604@redhat.com>
Date: Tue, 17 Jan 2012 11:44:32 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Colin Walters <walters@verbum.org>
CC: Minchan Kim <minchan@kernel.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, leonid.moiseichuk@nokia.com,
        kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, mel@csn.ul.ie,
        rientjes@google.com, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>
Subject: Re: [RFC 0/3] low memory notify
References: <1326788038-29141-1-git-send-email-minchan@kernel.org> <1326811093.3467.41.camel@lenny>
In-Reply-To: <1326811093.3467.41.camel@lenny>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 09:38 AM, Colin Walters wrote:

> How does this relate to the existing cgroups memory notifications?  See
> Documentation/cgroups/memory.txt under "10. OOM Control"

> As far as the desktop goes, I want to get notified if we're going to hit
> swap, not if we're close to exhausting the total of RAM+swap.  While
> swap may make sense for servers that care about throughput mainly, I
> care a lot about latency.

You just answered your own question :)

This code is indeed meant to avoid/reduce swap use and
improve userspace latencies.

Minchan posted a very simple example patch set, so we
can get an idea in what direction people would want
the code to go.  This often beats working on complex
code for weeks, and then having people tell you they
wanted something else :)

-- 
All rights reversed
