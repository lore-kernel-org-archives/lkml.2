Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab3AJC1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 21:27:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757938Ab3AJC1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 21:27:40 -0500
Date: Thu, 10 Jan 2013 00:27:23 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        walken@google.com, eric.dumazet@gmail.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, mingo@redhat.com
Subject: Re: [PATCH 0/5] x86,smp: make ticket spinlock proportional backoff
 w/ auto tuning
Message-ID: <20130110022722.GA1636@x61.redhat.com>
References: <20130108172632.1126898a@annuminas.surriel.com>
 <50ED679B.9020306@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50ED679B.9020306@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 06:20:35PM +0530, Raghavendra K T wrote:
> I ran kernbench on 32 core (mx3850) machine with 3.8-rc2 base.
> x base_3.8rc2
> + rik_backoff
>     N           Min           Max        Median           Avg        Stddev
> x   8       222.977        231.16       227.735       227.388     3.1512986
> +   8        218.75       232.347      229.1035     228.25425     4.2730225
> No difference proven at 95.0% confidence

I got similar results on smaller systems (1 socket, dual-cores and quad-cores)
when running Rik's latest series, no big difference for good nor for worse,
but I also think Rik's work is meant to address bigger systems with more cores
contending for any given spinlock.


