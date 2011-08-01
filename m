Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1HAXp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:45:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32784 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab1HAXpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:45:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E373A80.3090206@jp.fujitsu.com>
Date: Tue, 02 Aug 2011 08:45:04 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: khlebnikov@openvz.org
CC: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] mm: reverse lru scanning order
References: <20110727111002.9985.94938.stgit@localhost6> <4E36D110.30407@openvz.org>
In-Reply-To: <4E36D110.30407@openvz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/08/02 1:15), Konstantin Khlebnikov wrote:
> sorry, this patch is broken.

If you resend a _tested_ patch, I'll ack this one.

Thanks.


> 
> Konstantin Khlebnikov wrote:
>> LRU scanning order was accidentially changed in commit v2.6.27-5584-gb69408e:
>> "vmscan: Use an indexed array for LRU variables".
>> Before that commit reclaimer always scan active lists first.
>>
>> This patch just reverse it back.
>> This is just notice and question: "Does it affect something?"

