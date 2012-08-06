Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab2HFB2H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 21:28:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab2HFB2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 21:28:04 -0400
Message-ID: <501F1D86.7020409@redhat.com>
Date: Sun, 05 Aug 2012 21:27:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: peterz@infradead.org, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v2 5/9] rbtree: handle 1-child recoloring in rb_erase()
 instead of rb_erase_color()
References: <1343946858-8170-1-git-send-email-walken@google.com> <1343946858-8170-6-git-send-email-walken@google.com>
In-Reply-To: <1343946858-8170-6-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 06:34 PM, Michel Lespinasse wrote:
> An interesting observation for rb_erase() is that when a node has
> exactly one child, the node must be black and the child must be red.
> An interesting consequence is that removing such a node can be done by
> simply replacing it with its child and making the child black,
> which we can do efficiently in rb_erase(). __rb_erase_color() then
> only needs to handle the no-childs case and can be modified accordingly.
>
> Signed-off-by: Michel Lespinasse<walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
