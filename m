Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab2GXSu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 14:50:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106Ab2GXSuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 14:50:25 -0400
Message-ID: <500EEE60.4060507@redhat.com>
Date: Tue, 24 Jul 2012 14:50:08 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: peterz@infradead.org, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] rbtree: rb_erase updates and comments
References: <1342787467-5493-1-git-send-email-walken@google.com> <1342787467-5493-2-git-send-email-walken@google.com>
In-Reply-To: <1342787467-5493-2-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 08:31 AM, Michel Lespinasse wrote:
> Minor updates to the rb_erase() function:
> - Reorder code to put simplest / common case (no more than 1 child) first.
> - Fetch the parent first, since it ends up being required in all 3 cases.
> - Add a few comments to illustrate case 2 (node to remove has 2 childs,
>    but one of them is the successor) and case 3 (node to remove has 2 childs,
>    successor is a left-descendant of the right child).
>
> Signed-off-by: Michel Lespinasse<walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
