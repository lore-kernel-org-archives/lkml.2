Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab1GYDrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 23:47:35 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64853 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab1GYDr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 23:47:28 -0400
MIME-Version: 1.0
In-Reply-To: <87vcurrrad.fsf@gmail.com>
References: <cover.1291568905.git.minchan.kim@gmail.com>
	<0724024711222476a0c8deadb5b366265b8e5824.1291568905.git.minchan.kim@gmail.com>
	<20101208170504.1750.A69D9226@jp.fujitsu.com>
	<AANLkTikG1EAMm8yPvBVUXjFz1Bu9m+vfwH3TRPDzS9mq@mail.gmail.com>
	<87oc8wa063.fsf@gmail.com>
	<AANLkTin642NFLMubtCQhSVUNLzfdk5ajz-RWe2zT+Lw6@mail.gmail.com>
	<20101213153105.GA2344@barrios-desktop>
	<87lj3t30a9.fsf@gmail.com>
	<AANLkTikT_HNvuBR0J-2COgB54gquj2FineOjkzU+mt6_@mail.gmail.com>
	<87vcurrrad.fsf@gmail.com>
Date: Mon, 25 Jul 2011 12:47:25 +0900
Message-ID: <CAEwNFnBnsi6WePqqo_8ES4Zxa2JZ43_7PHcO1ABh5+hwopSngA@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] Reclaim invalidated page ASAP
From: Minchan Kim <minchan.kim@gmail.com>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Mon, Jul 25, 2011 at 12:08 PM, Ben Gamari <bgamari.foss@gmail.com> wrote:
> On Tue, 14 Dec 2010 11:36:12 +0900, Minchan Kim <minchan.kim@gmail.com> wrote:
>> Hi Ben,
>>
>> [snipped]
>
> What exactly happened to this set? It seems it dropped off my radar and
> otherwise never was merged. Was it not tested enough, the benefit not
> great enough, or did it simply slip through the cracks?

It is already merged.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=315601809d124d046abd6c3ffa346d0dbd7aa29d

Thanks.

-- 
Kind regards,
Minchan Kim
