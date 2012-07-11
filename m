Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab2GKPsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:48:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55908 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758154Ab2GKPsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:48:47 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Michel Lespinasse" <walken@google.com>
Cc: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com, linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 04/13] rbtree: move some implementation details from
 rbtree.h to rbtree.c
References: <1341876923-12469-1-git-send-email-walken@google.com>
 <1341876923-12469-5-git-send-email-walken@google.com>
 <op.wg8ciikk3l0zgt@mpn-glaptop>
 <CANN689E8_5YPCu9WMfgSAbBFkQYhfQkoYejdGRd-NPSiFhVuTg@mail.gmail.com>
Date: Wed, 11 Jul 2012 17:48:37 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.whagvbgg3l0zgt@mpn-glaptop>
In-Reply-To: <CANN689E8_5YPCu9WMfgSAbBFkQYhfQkoYejdGRd-NPSiFhVuTg@mail.gmail.com>
User-Agent: Opera Mail/12.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012 01:12:54 +0200, Michel Lespinasse <walken@google.com> wrote:

> On Tue, Jul 10, 2012 at 5:19 AM, Michal Nazarewicz <mina86@mina86.com> wrote:
>> On Tue, 10 Jul 2012 01:35:14 +0200, Michel Lespinasse <walken@google.com> wrote:
>>> +#define        RB_RED          0
>>> +#define        RB_BLACK        1
>>
>> Interestingly, those are almost never used. RB_BLACK is used only once.
>> Should we get rid of those instead?  Or change the code (like rb_is_red())
>> to use them?
>
> I'm actually making heavier use of RB_RED / RB_BLACK later on in the patch set.

Yeah, I've just noticed.  Disregard my comment.

> But agree, rb_is_red() / rb_is_black() could use these too.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
