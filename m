Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2GXVwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:52:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab2GXVwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:52:34 -0400
Message-ID: <500F1917.2050308@redhat.com>
Date: Tue, 24 Jul 2012 17:52:23 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: peterz@infradead.org, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] rbtree: optimize fetching of sibling node
References: <1342787467-5493-1-git-send-email-walken@google.com> <1342787467-5493-3-git-send-email-walken@google.com>
In-Reply-To: <1342787467-5493-3-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 08:31 AM, Michel Lespinasse wrote:
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
