Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0EDESN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 00:18:13 -0400
Received: from 1wt.eu ([62.212.114.60]:63667 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab0EDESJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 00:18:09 -0400
Date: Tue, 4 May 2010 06:16:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Renninger <trenn@suse.de>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org, riel@redhat.com
Subject: Re: [PATCH 8/7] cpufreq: make the iowait-is-busy-time a sysfs
 tunable
Message-ID: <20100504041657.GC13686@1wt.eu>
References: <20100418115949.7b743898@infradead.org>
 <201004231050.10667.trenn@suse.de>
 <20100423090819.4273b327@infradead.org>
 <201004271339.34711.trenn@suse.de>
 <20100503204818.7b801f43@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503204818.7b801f43@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 08:48:18PM -0700, Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] cpufreq: make the iowait-is-busy-time a sysfs tunable
> 
> Pavel Machek pointed out that not all CPUs have an efficient idle
> at high frequency. Specifically, older Intel and various AMD cpus
> would get a higher power usage when copying files from USB.
> 
> Mike Chan pointed out that the same is true for various ARM chips
> as well.
> 
> Thomas Renninger suggested to make this a sysfs tunable with a
> reasonable default.
> 
> This patch adds a sysfs tunable for the new behavior, and uses
> a very simple function to determine a reasonable default, depending
> on the CPU vendor/type.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---

That's very nice Arjan. That way we'll be able to select between
performance and power savings, which is what most laptop users
want after all !

Thanks,
Willy

