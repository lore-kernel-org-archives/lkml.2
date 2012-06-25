Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab2FYWbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:31:49 -0400
Received: from mx2.parallels.com ([64.131.90.16]:53537 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545Ab2FYWbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:31:48 -0400
Message-ID: <4FE8E632.70602@parallels.com>
Date: Tue, 26 Jun 2012 02:29:06 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 01/11] memcg: Make it possible to use the stock for more
 than one page.
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-2-git-send-email-glommer@parallels.com> <20120625174437.GC3869@google.com>
In-Reply-To: <20120625174437.GC3869@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.173.9.3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 09:44 PM, Tejun Heo wrote:
> Hey, Glauber.
>
> Just a couple nits.
>
> On Mon, Jun 25, 2012 at 06:15:18PM +0400, Glauber Costa wrote:
>> From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
>
> It would be nice to explain why this is being done.  Just a simple
> statement like - "prepare for XXX" or "will be needed by XXX".

I picked this patch from Suleiman Souhlal, and tried to keep it as close 
as possible to his version.

But for the sake of documentation, I can do that, yes.
