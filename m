Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2HEXVJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 19:21:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183Ab2HEXVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 19:21:07 -0400
Message-ID: <501EFFC2.6090700@redhat.com>
Date: Sun, 05 Aug 2012 19:20:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: peterz@infradead.org, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v2 2/9] rbtree: optimize fetching of sibling node
References: <1343946858-8170-1-git-send-email-walken@google.com> <1343946858-8170-3-git-send-email-walken@google.com>
In-Reply-To: <1343946858-8170-3-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 06:34 PM, Michel Lespinasse wrote:
> When looking to fetch a node's sibling, we went through a sequence of:
> - check if node is the parent's left child
> - if it is, then fetch the parent's right child
>
> This can be replaced with:
> - fetch the parent's right child as an assumed sibling
> - check that node is NOT the fetched child
>
> This avoids fetching the parent's left child when node is actually
> that child. Saves a bit on code size, though it doesn't seem to make
> a large difference in speed.
>
> Signed-off-by: Michel Lespinasse<walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
