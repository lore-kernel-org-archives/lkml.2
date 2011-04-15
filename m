Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab1DOKrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 06:47:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:58191 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631Ab1DOKrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 06:47:04 -0400
Date: Fri, 15 Apr 2011 11:47:00 +0100
From: Mel Gorman <mgorman@suse.de>
To: azurIt <azurit@pobox.sk>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Changli Gao <xiaosuo@gmail.com>,
        Am?rico Wang <xiyou.wangcong@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Regression from 2.6.36
Message-ID: <20110415104700.GD22688@suse.de>
References: <1302178426.3357.34.camel@edumazet-laptop>
 <BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>
 <1302190586.3357.45.camel@edumazet-laptop>
 <20110412154906.70829d60.akpm@linux-foundation.org>
 <BANLkTincoaxp5Soe6O-eb8LWpgra=k2NsQ@mail.gmail.com>
 <20110412183132.a854bffc.akpm@linux-foundation.org>
 <1302662256.2811.27.camel@edumazet-laptop>
 <20110413141600.28793661.akpm@linux-foundation.org>
 <20110414102501.GE11871@csn.ul.ie>
 <20110415115903.315DEAA1@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110415115903.315DEAA1@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 11:59:03AM +0200, azurIt wrote:
> 
> Also this new patch is working fine and fixing the problem.
> 
> Mel, I cannot run your script:
> # perl watch-highorder-latency.pl
> Failed to open /sys/kernel/debug/tracing/set_ftrace_filter for writing at watch-highorder-latency.pl line 17.
> 
> # ls -ld /sys/kernel/debug/
> ls: cannot access /sys/kernel/debug/: No such file or directory
> 

mount -t debugfs none /sys/kernel/debug

If it still doesn't work, sysfs or the necessary FTRACE options are
not enabled on your .config. I'll give you a list if that is the case.

Thanks.

-- 
Mel Gorman
SUSE Labs
