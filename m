Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1ELLNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 07:13:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51184 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab1ELLNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 07:13:45 -0400
Message-ID: <4DCBC0E8.5020609@cs.helsinki.fi>
Date: Thu, 12 May 2011 14:13:44 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 0/3] Reduce impact to overall system of SLUB using high-order
 allocations
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>	 <1305149960.2606.53.camel@mulgrave.site>	 <alpine.DEB.2.00.1105111527490.24003@chino.kir.corp.google.com> <1305153267.2606.57.camel@mulgrave.site>
In-Reply-To: <1305153267.2606.57.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/12/11 1:34 AM, James Bottomley wrote:
> On Wed, 2011-05-11 at 15:28 -0700, David Rientjes wrote:
>> On Wed, 11 May 2011, James Bottomley wrote:
>>
>>> OK, I confirm that I can't seem to break this one.  No hangs visible,
>>> even when loading up the system with firefox, evolution, the usual
>>> massive untar, X and even a distribution upgrade.
>>>
>>> You can add my tested-by
>>>
>> Your system still hangs with patches 1 and 2 only?
> Yes, but only once in all the testing.  With patches 1 and 2 the hang is
> much harder to reproduce, but it still seems to be present if I hit it
> hard enough.

Patches 1-2 look reasonable to me. I'm not completely convinced of patch 
3, though. Why are we seeing these problems now? This has been in 
mainline for a long time already. Shouldn't we fix kswapd?

                         Pekka
