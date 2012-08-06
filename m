Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab2HFUuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:50:13 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61394 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab2HFUuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:50:11 -0400
MIME-Version: 1.0
In-Reply-To: <1344262863.27828.56.camel@twins>
References: <1343946858-8170-1-git-send-email-walken@google.com>
	<1343946858-8170-7-git-send-email-walken@google.com>
	<1344262863.27828.56.camel@twins>
Date: Mon, 6 Aug 2012 13:50:02 -0700
Message-ID: <CANN689Gcca_Xr8GQSjJads8psz3PZpya+s8aWTt_goVt0+O4YA@mail.gmail.com>
Subject: Re: [PATCH v2 6/9] rbtree: low level optimizations in rb_erase()
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 7:21 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-08-02 at 15:34 -0700, Michel Lespinasse wrote:
>> +                       /* Case 3: node's successor is leftmost under its
>> +                        * right child subtree
>
> Hmm?

Would 'leftmost under node's right child subtree' make more sense ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
