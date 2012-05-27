Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751089Ab2E0EhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 00:37:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44661 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2E0EhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 00:37:09 -0400
MIME-Version: 1.0
In-Reply-To: <1338050385.10390.2.camel@laptop>
References: <1338000869-15129-1-git-send-email-ming.lei@canonical.com>
	<1338016564.14636.4.camel@twins>
	<CACVXFVNBiXxVvRWxnXiKPRm5dkj6qziFtXA_OH5kYFg4GZ+-pQ@mail.gmail.com>
	<1338050385.10390.2.camel@laptop>
Date: Sun, 27 May 2012 12:37:06 +0800
Message-ID: <CACVXFVNfAc-SwPMhf1RwNEEWY_4jZEEx3kMk_MV=pY02d750Kw@mail.gmail.com>
Subject: Re: [PATCH] tty: tty_mutex: fix lockdep warning in tty_lock_pair(v3)
From: Ming Lei <ming.lei@canonical.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, May 27, 2012 at 12:39 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, 2012-05-26 at 17:23 +0800, Ming Lei wrote:
>>
>> You mean that the below is good usage of lock?
>>
>>         LOCK A
>>         LOCK B
>>
>>         UNLOCK A
>>         UNLOCK B
>
> Yep, nothing wrong with that. Its lock order that matters, unlock very
> much not so.

OK.

Also I tested your patch in the link below again and it is OK.

     http://marc.info/?l=linux-kernel&m=133728068726465&w=2

Sorry for my fault because the patch above can't be applied cleanly
against -next and I edited it manually to cause the previous test
mistake.

Greg and Peter, so I recall this patch and Peter may send a formal
one for merge.

Thanks,
--
Ming Lei
