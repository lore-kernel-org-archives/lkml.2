Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0DZVBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:01:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab0DZVBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:01:38 -0400
Message-ID: <4BD5FEFF.9000304@redhat.com>
Date: Mon, 26 Apr 2010 17:00:47 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 5/7] sched: eliminate the ts->idle_lastupdate field
References: <20100418115949.7b743898@infradead.org> <20100418120258.09c95042@infradead.org>
In-Reply-To: <20100418120258.09c95042@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2010 03:02 PM, Arjan van de Ven wrote:
>  From 526a9f347d5a953f37b67b4b2afb39d7b4d77a92 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven<arjan@linux.intel.com>
> Date: Sun, 18 Apr 2010 10:49:30 -0700
> Subject: [PATCH 5/7] sched: eliminate the ts->idle_lastupdate field
>
> Now that the only user of ts->idle_lastupdate is update_ts_time_stats(),
> the entire field can be eliminated.
>
> In update_ts_time_stats(), idle_lastupdate is first set to "now",
> and a few lines later, the only user is an if() statement that
> assigns a variable either to "now" or to ts->idle_lastupdate,
> which has the value of "now" at that point.
>
> Signed-off-by: Arjan van de Ven<arjan@linux.intel.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
