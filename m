Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab2E3U6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:58:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40653 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2E3U6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:58:51 -0400
Message-ID: <4FC68A08.7000708@gmail.com>
Date: Wed, 30 May 2012 16:58:48 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@google.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, stable@vger.kernel.org,
        hughd@google.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/6] mempolicy: Kill all mempolicy sharing
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com> <1338368529-21784-3-git-send-email-kosaki.motohiro@gmail.com> <m2vcjdjtr9.fsf@firstfloor.org>
In-Reply-To: <m2vcjdjtr9.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/30/12 4:31 PM), Andi Kleen wrote:
> kosaki.motohiro@gmail.com writes:
>
>> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>>
>> Dave Jones' system call fuzz testing tool "trinity" triggered the following
>> bug error with slab debugging enabled
>
> We have to fix it properly sorry. There are users who benefit from it
> and just disabling it is not gonna fly.

Why? This patch doesn't make any user visible behavior change. I haven't
caught what does your "proper" mean.



