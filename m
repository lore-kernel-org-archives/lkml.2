Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab0IAWSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 18:18:43 -0400
Received: from smtp-out.google.com ([74.125.121.35]:57637 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab0IAWSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 18:18:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=WWmXO/C/8dod6ECBoT052u5aZLZT9EGdyzlvJy+p160R3jAw3mLT/+4S1kdQO/a9l
	iYdoSs6GzZRH+xPRgMKpQ==
Date: Wed, 1 Sep 2010 15:18:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [BUGFIX for 2.6.36][RESEND][PATCH 1/2] oom: remove totalpage
 normalization from oom_badness()
In-Reply-To: <20100831181911.87E7.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1009011508440.29305@chino.kir.corp.google.com>
References: <20100831181911.87E7.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010, KOSAKI Motohiro wrote:

> ok, this one got no objection except original patch author.

Would you care to respond to my objections?

I replied to these two patches earlier with my nack, here they are:

	http://marc.info/?l=linux-mm&m=128273555323993
	http://marc.info/?l=linux-mm&m=128337879310476

Please carry on a useful debate of the issues rather than continually 
resending patches and labeling them as bugfixes, which they aren't.

> then, I'll push it to mainline. I'm glad that I who stabilization
> developer have finished this work.
> 

You're not the maintainer of this code, patches go through Andrew.

That said, I'm really tired of you trying to make this personal with me; 
I've been very respectful and accomodating during this discussion and I 
hope that you will be the same.

Thanks.
