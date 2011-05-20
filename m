Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935428Ab1ETRRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 13:17:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933727Ab1ETRRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 13:17:13 -0400
Message-ID: <4DD6A20B.3070800@redhat.com>
Date: Fri, 20 May 2011 13:16:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Barry <abarry@cray.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Unending loop in __alloc_pages_slowpath following OOM-kill; rfc:
 patch.
References: <4DCDA347.9080207@cray.com> <BANLkTikiXUzbsUkzaKZsZg+5ugruA2JdMA@mail.gmail.com> <4DD2991B.5040707@cray.com> <BANLkTimYEs315jjY9OZsL6--mRq3O_zbDA@mail.gmail.com> <20110520164924.GB2386@barrios-desktop>
In-Reply-To: <20110520164924.GB2386@barrios-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2011 12:49 PM, Minchan Kim wrote:

> From: Andrew Barry<abarry@cray.com>
>
> I believe I found a problem in __alloc_pages_slowpath, which allows a process to
> get stuck endlessly looping, even when lots of memory is available.

> Signed-off-by: Andrew Barry<abarry@cray.com>
> Reviewed-by: Minchan Kim<minchan.kim@gmail.com>
> Cc: Mel Gorman<mgorman@suse.de>

Reviewed-by: Rik van Riel<riel@redhat.com>

-- 
All rights reversed
