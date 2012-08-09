Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab2HIBk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 21:40:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab2HIBkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 21:40:25 -0400
Message-ID: <502314FD.7090701@redhat.com>
Date: Wed, 08 Aug 2012 21:40:13 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v6 3/3] mm: add vm event counters for balloon pages compaction
References: <cover.1344463786.git.aquini@redhat.com> <768e09520a249fd78f706cd8ae53d511f9db0aaa.1344463786.git.aquini@redhat.com>
In-Reply-To: <768e09520a249fd78f706cd8ae53d511f9db0aaa.1344463786.git.aquini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 06:53 PM, Rafael Aquini wrote:
> This patch is only for testing report purposes and shall be dropped in case of
> the rest of this patchset getting accepted for merging.

I wonder if it would make sense to just keep these statistics, so
if a change breaks balloon migration in the future, we'll be able
to see it...

> Signed-off-by: Rafael Aquini<aquini@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
