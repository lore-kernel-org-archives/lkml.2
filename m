Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab0DZU7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:59:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab0DZU66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:58:58 -0400
Message-ID: <4BD5FE5B.6030708@redhat.com>
Date: Mon, 26 Apr 2010 16:58:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 4/7] sched: fold updating of the last update time into
 update_ts_time_stats()
References: <20100418115949.7b743898@infradead.org> <20100418120224.5447dec3@infradead.org>
In-Reply-To: <20100418120224.5447dec3@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2010 03:02 PM, Arjan van de Ven wrote:
>  From e75d6cd203e43ea4c5e9919f19e2882c066491b8 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven<arjan@linux.intel.com>
> Date: Sun, 18 Apr 2010 10:47:02 -0700
> Subject: [PATCH 4/7] sched: fold updating of the last update time into update_ts_time_stats()
>
> This patch folds the updating of the last_update_time into the
> update_ts_time_stats() function, and updates the callers.
>
> This allows for further cleanups that are done in the next patch.
>
> Signed-off-by: Arjan van de Ven<arjan@linux.intel.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
