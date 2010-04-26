Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab0DZUg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:36:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab0DZUg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:36:26 -0400
Message-ID: <4BD5F930.7010409@redhat.com>
Date: Mon, 26 Apr 2010 16:36:00 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 3/7] sched: update the idle statistics in get_cpu_idle_time_us()
References: <20100418115949.7b743898@infradead.org> <20100418120150.383061b5@infradead.org>
In-Reply-To: <20100418120150.383061b5@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2010 03:01 PM, Arjan van de Ven wrote:
>  From 60851b131900af03bf013afef69f3bcdbb04f1d6 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven<arjan@linux.intel.com>
> Date: Sun, 18 Apr 2010 10:41:30 -0700
> Subject: [PATCH 3/7] sched: update the idle statistics in get_cpu_idle_time_us()
>
> Right now, get_cpu_idle_time_us() only reports the idle statistics
> upto the point the CPU entered last idle; not what is valid right now.
>
> This patch adds an update of the idle statistics to get_cpu_idle_time_us(),
> so that calling this function always returns statistics that are accurate
> at the point of the call.
>
> This includes resetting the start of the idle time for accounting purposes
> to avoid double accounting.
>
> Signed-off-by: Arjan van de Ven<arjan@linux.intel.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
