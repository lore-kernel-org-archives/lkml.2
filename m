Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab2BWHg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 02:36:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51708 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab2BWHg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 02:36:27 -0500
Message-ID: <4F45ED29.7020009@cn.fujitsu.com>
Date: Thu, 23 Feb 2012 15:39:21 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [RFD] cgroup: about multiple hierarchies
References: <20120221211938.GE12236@google.com> <1329917459.24994.14.camel@twins>
In-Reply-To: <1329917459.24994.14.camel@twins>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-23 15:34:39,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-23 15:34:41,
	Serialize complete at 2012-02-23 15:34:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Another thing I dislike about all the cgroup crap is all the dozens of
> tiny controllers being proposed left right and center. Like WTF isn't
> the hugetlb controller part of memcg? Its all memory, right?
> 

We also have two network controllers - net_cls and net_prio.
Patches were sent to netdev only, so I didn't see them until
they hit mainline.
