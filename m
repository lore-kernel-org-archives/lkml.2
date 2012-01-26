Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab2AZKw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 05:52:29 -0500
Received: from app1b.xlhost.de ([213.202.242.162]:42345 "EHLO app1b.xlhost.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab2AZKw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 05:52:27 -0500
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jan 2012 05:52:27 EST
Message-ID: <4F212F09.4090802@5t9.de>
Date: Thu, 26 Jan 2012 11:46:33 +0100
From: Lutz Vieweg <lvml@5t9.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: preallocate page before lock_page at filemap COW.
 (WasRe: [PATCH V2] mm: Do not keep page locked during page fault while charging
 it for memcg
References: <20110622120635.GB14343@tiehlicka.suse.cz> <20110622121516.GA28359@infradead.org> <20110622123204.GC14343@tiehlicka.suse.cz> <20110623150842.d13492cd.kamezawa.hiroyu@jp.fujitsu.com> <20110623074133.GA31593@tiehlicka.suse.cz> <20110623170811.16f4435f.kamezawa.hiroyu@jp.fujitsu.com> <20110623090204.GE31593@tiehlicka.suse.cz> <20110623190157.1bc8cbb9.kamezawa.hiroyu@jp.fujitsu.com> <20110624075742.GA10455@tiehlicka.suse.cz> <BANLkTin7TbK1dNjPG6jz_FaJy-QgOjDJaA@mail.gmail.com> <20110712094841.GC10552@tiehlicka.suse.cz>
In-Reply-To: <20110712094841.GC10552@tiehlicka.suse.cz>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 11:48 AM, Michal Hocko wrote:
> Is there any intereset in discussing this or the email just got lost?
> Just for reference preallocation patch from Kamezawa is already in the
> Andrew's tree.

It's been a long time since this discussion, I just wanted to add
that I've been recently able to confirm the ability of memcg
to prevent single users from DOSing a system by "make -j" - in
a real-world scenario (using linux-3.2.1).

So thanks to all who contributed to the solution in whatever way :-)

(A minor issue remained: The kernel is very verbose when
killing tasks due to memcg restrictions. In fork-bomb like
scenarios, this can lead to high resource utilization for
syslog et al.)

Regards,

Lutz Vieweg

