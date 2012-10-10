Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab2JJU1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:27:30 -0400
Received: from mx2.parallels.com ([64.131.90.16]:46291 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582Ab2JJU13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:27:29 -0400
Message-ID: <5075DA1D.60006@parallels.com>
Date: Thu, 11 Oct 2012 00:27:09 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [patch for-linus] memcg, kmem: fix build error when CONFIG_INET
 is disabled
References: <alpine.DEB.2.00.1210092325500.9528@chino.kir.corp.google.com> <5075383A.1000001@parallels.com> <20121010092700.GD23011@dhcp22.suse.cz> <50753FFF.6060102@parallels.com> <20121010143331.GA7880@localhost> <alpine.DEB.2.00.1210101312330.28583@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210101312330.28583@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.173.3.27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 12:17 AM, David Rientjes wrote:
> On Wed, 10 Oct 2012, Fengguang Wu wrote:
> 
>>> Fengguang, was that this error? Why hasn't it showed up before in the
>>> test system?
>>
>> I do find this error in the build error log:
>>
>>         (.text+0x867f): undefined reference to `sock_update_memcg'
>>         2012-09-24 04:54:53 snb next:akpm:69921c3 x86_64-randconfig-s005 0a7f618
>>
>> Unfortunately it was not reported because the build system could
>> miss/ignore build bugs due to various reasons/imperfections. It has
>> since then undergo lots of enhancements and as a result, the daily
>> reported errors have more than doubled. :-)
>>
> 
> Not sure where this discussion is going.  Do people who can't build their 
> kernel and have a fix for it need to verify that your build system shows 
> the same thing first?  This isn't a false positive.
> 
> As I said in the first message, Randy reported this on September 24 (the 
> same date you're reporting above) and received no response when he 
> reported it to LKML here: 
> http://marc.info/?l=linux-kernel&m=134852557320089
> 
> Regardless, Linus' tree is messed up and I don't think we need to go back 
> reverting patches out of his tree when it's trivial to fix with my patch, 
> which Michal acked.  Sheesh.
> 
I am perfectly fine with your patch.

As I said when he first posted it: I see no reason to oppose cleanup
patches, as long as they don't break anything. Unfortunately it did, but
that is water under the bridge.

Again, since the goal of Michal patches was just to move things around,
I don't really care if you patch is applied or if Michal's is reverted.



