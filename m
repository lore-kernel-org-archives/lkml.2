Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab1EXJgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:36:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60983 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab1EXJgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:36:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB7C1D.8040300@jp.fujitsu.com>
Date: Tue, 24 May 2011 18:36:29 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: minchan.kim@gmail.com
CC: abarry@cray.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mgorman@suse.de, riel@redhat.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: Unending loop in __alloc_pages_slowpath following OOM-kill; rfc:
 patch.
References: <4DCDA347.9080207@cray.com>	<BANLkTikiXUzbsUkzaKZsZg+5ugruA2JdMA@mail.gmail.com>	<4DD2991B.5040707@cray.com>	<BANLkTimYEs315jjY9OZsL6--mRq3O_zbDA@mail.gmail.com>	<20110520164924.GB2386@barrios-desktop>	<4DDB3A1E.6090206@jp.fujitsu.com>	<BANLkTinkcu5j1H8tHNT4aTmOL-GXfSwPQw@mail.gmail.com>	<4DDB6F48.1010809@jp.fujitsu.com> <BANLkTimbu0pDNb1cHGu0B6P-foRHQ2uiWw@mail.gmail.com>
In-Reply-To: <BANLkTimbu0pDNb1cHGu0B6P-foRHQ2uiWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Can you please tell me previous discussion url or mail subject?
>> I mean, if it is costly and performance degression risk, we don't have to
>> take my idea.
> 
> Yes. You could see it by https://lkml.org/lkml/2011/4/30/81.

I think Wu pointed out "lightweight vmscan could reclaim pages but stealed
from another task case". It's very different with "most heavyweight vmscan
still failed to reclaim any pages". The point is, IPIs cost depend on the
frequency. stealing frequently occur on current logic, but vmscan priority==0
is?



