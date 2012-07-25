Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2GYSA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:00:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab2GYSA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:00:57 -0400
Message-ID: <501033F7.9090002@redhat.com>
Date: Wed, 25 Jul 2012 13:59:19 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: peterz@infradead.org, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] rbtree: remove prior augmented rbtree implementation
References: <1342787467-5493-1-git-send-email-walken@google.com> <1342787467-5493-7-git-send-email-walken@google.com> <20120724015505.GB9690@google.com>
In-Reply-To: <20120724015505.GB9690@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2012 09:55 PM, Michel Lespinasse wrote:
> convert arch/x86/mm/pat_rbtree.c to the proposed augmented rbtree api
> and remove the old augmented rbtree implementation.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>


I'm looking forward to using your new augmented rbtree
code for the rbtree based arch_get_unmapped_area code.
It should provide a nice speedup on munmap.


