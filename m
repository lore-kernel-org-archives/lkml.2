Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1FTRHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:07:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab1FTRHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:07:21 -0400
Message-ID: <4DFF7E3B.1040404@redhat.com>
Date: Tue, 21 Jun 2011 01:07:07 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: completely disable THP by transparent_hugepage=never
References: <1308587683-2555-1-git-send-email-amwang@redhat.com> <20110620165844.GA9396@suse.de>
In-Reply-To: <20110620165844.GA9396@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月21日 00:58, Mel Gorman 写道:
> On Tue, Jun 21, 2011 at 12:34:28AM +0800, Amerigo Wang wrote:
>> transparent_hugepage=never should mean to disable THP completely,
>> otherwise we don't have a way to disable THP completely.
>> The design is broken.
>>
>
> I don't get why it's broken. Why would the user be prevented from
> enabling it at runtime?
>

We need to a way to totally disable it, right? Otherwise, when I configure
THP in .config, I always have THP initialized even when I pass "=never".

For me, if you don't provide such way to disable it, it is not flexible.

I meet this problem when I try to disable THP in kdump kernel, there is
no user of THP in kdump kernel, THP is a waste for kdump kernel. This is
why I need to find a way to totally disable it.

Thanks.
