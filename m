Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab1FTRRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:17:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab1FTRRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:17:07 -0400
Message-ID: <4DFF8050.9070201@redhat.com>
Date: Tue, 21 Jun 2011 01:16:00 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: make the threshold of enabling THP configurable
References: <1308587683-2555-1-git-send-email-amwang@redhat.com> <1308587683-2555-2-git-send-email-amwang@redhat.com> <20110620165955.GB9396@suse.de>
In-Reply-To: <20110620165955.GB9396@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月21日 00:59, Mel Gorman 写道:
> On Tue, Jun 21, 2011 at 12:34:29AM +0800, Amerigo Wang wrote:
>> Don't hard-code 512M as the threshold in kernel, make it configruable,
>> and set 512M by default.
>>
>
> I'm not seeing the gain here either. This is something that is going to
> be set by distributions and probably never by users. If the default of
> 512 is incorrect, what should it be? Also, the Kconfig help message has
> spelling errors.
>

Sorry for spelling errors, I am not an English speaker.

Hard-coding is almost never a good thing in kernel, enforcing 512
is not good either. Since the default is still 512, I don't think this
will affect much users.

I do agree to improve the help message, like Dave mentioned in his reply,
but I don't like enforcing a hard-coded number in kernel.

BTW, why do you think 512 is suitable for *all* users?

Thanks.
