Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab0DZUMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:12:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab0DZUMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:12:12 -0400
Message-ID: <4BD5F366.6080001@redhat.com>
Date: Mon, 26 Apr 2010 16:11:18 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 2/7] sched: introduce a function to update the idle statistics
References: <20100418115949.7b743898@infradead.org> <20100418120122.2f577bd8@infradead.org>
In-Reply-To: <20100418120122.2f577bd8@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2010 03:01 PM, Arjan van de Ven wrote:
>  From 166b7526ccfea8b44626b6023ff5b0a8eb869bb3 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven<arjan@linux.intel.com>
> Date: Sun, 18 Apr 2010 10:33:02 -0700
> Subject: [PATCH 2/7] sched: introduce a function to update the idle statistics
>
> Currently, two places update the idle statistics (and more to
> come later in this series).
>
> This patch creates a helper function for updating these statistics.
>
> Signed-off-by: Arjan van de Ven<arjan@linux.intel.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
