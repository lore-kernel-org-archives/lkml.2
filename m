Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab2HFBBj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 21:01:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084Ab2HFBBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 21:01:12 -0400
Message-ID: <501F171F.50001@redhat.com>
Date: Sun, 05 Aug 2012 21:00:15 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: peterz@infradead.org, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v2 3/9] rbtree: add __rb_change_child() helper function
References: <1343946858-8170-1-git-send-email-walken@google.com> <1343946858-8170-4-git-send-email-walken@google.com>
In-Reply-To: <1343946858-8170-4-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 06:34 PM, Michel Lespinasse wrote:
> Add __rb_change_child() as an inline helper function to replace code that
> would otherwise be duplicated 4 times in the source.
>
> No changes to binary size or speed.
>
> Signed-off-by: Michel Lespinasse<walken@google.com>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
