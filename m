Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab0DZT0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:26:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab0DZT0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:26:24 -0400
Message-ID: <4BD5E8C4.7040308@redhat.com>
Date: Mon, 26 Apr 2010 15:25:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 1/7] sched: add a comment to get_cpu_idle_time_us()
References: <20100418115949.7b743898@infradead.org> <20100418120050.562d63a6@infradead.org>
In-Reply-To: <20100418120050.562d63a6@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2010 03:00 PM, Arjan van de Ven wrote:
>  From 6f9df3bc6571d6545c552151f408d69265e15f92 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven<arjan@linux.intel.com>
> Date: Sun, 18 Apr 2010 10:25:19 -0700
> Subject: [PATCH 1/7] sched: add a comment to get_cpu_idle_time_us()
>
> The exported function get_cpu_idle_time_us() has no comment
> describing it; add a kerneldoc comment
>
> Signed-off-by: Arjan van de Ven<arjan@linux.intel.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
