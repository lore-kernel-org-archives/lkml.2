Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab2KVVpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:45:33 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34930 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab2KVVpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:45:30 -0500
Date: Thu, 22 Nov 2012 22:45:27 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: memory-cgroup bug
Message-ID: <20121122214527.GB20319@dhcp22.suse.cz>
References: <20121121200207.01068046@pobox.sk>
 <50AD713F.9030909@jp.fujitsu.com>
 <20121122103618.79F03818@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121122103618.79F03818@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 22-11-12 10:36:18, azurIt wrote:
[...]
> I can look also to the data of 'freezed' proces if you need it but i
> will have to wait until problem occurs again.
> 
> The main problem is that when this problem happens, it's NOT resolved
> automatically by kernel/OOM and user of cgroup, where it happend, has
> non-working services until i kill his processes by hand. I'm sure
> that all 'freezed' processes are taking very much CPU because also
> server load goes really high - next time i will make a screenshot of
> htop. I really wonder why OOM is __sometimes__ not resolving this
> (it's usually is, only sometimes not).

What does your kernel log says while this is happening. Are there any
memcg OOM messages showing up?
-- 
Michal Hocko
SUSE Labs
