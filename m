Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0DZVHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:07:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab0DZVHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:07:12 -0400
Message-ID: <4BD6001D.5090403@redhat.com>
Date: Mon, 26 Apr 2010 17:05:33 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 6/7] sched: introduce get_cpu_iowait_time_us()
References: <20100418115949.7b743898@infradead.org> <20100418120321.11ad89a2@infradead.org>
In-Reply-To: <20100418120321.11ad89a2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2010 03:03 PM, Arjan van de Ven wrote:
>  From c4dd11703034f2ecbc3180603663fab14c292d7c Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven<arjan@linux.intel.com>
> Date: Sun, 18 Apr 2010 10:57:43 -0700
> Subject: [PATCH 6/7] sched: introduce get_cpu_iowait_time_us()
>
> For the ondemand cpufreq governor, it is desired that the iowait
> time is microaccounted in a similar way as idle time is.
>
> This patch introduces the infrastructure to account and expose
> this information via the get_cpu_iowait_time_us() function.
>
> Signed-off-by: Arjan van de Ven<arjan@linux.intel.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
