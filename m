Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab0IPQzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:55:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394Ab0IPQzh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:55:37 -0400
MIME-Version: 1.0
In-Reply-To: <1284654451.2275.579.camel@laptop>
References: <20100915104855.41de3ebf@lilo> <AANLkTimNsDxeyZL4GVaH4L7YGO-EoRyCMHDtMPWU37hN@mail.gmail.com>
 <1284654451.2275.579.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Sep 2010 09:54:50 -0700
Message-ID: <AANLkTinihPeUueKhEqUuraW2hcf3FFHjm26RieKQZi0d@mail.gmail.com>
Subject: Re: [RFC][PATCH] Cross Memory Attach
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 9:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-09-15 at 08:11 -0700, Linus Torvalds wrote:
>
>>    if (copy_to)
>>       ret = copy_from_user(..);
>>    else
>>       ret = copy_to_user(..);
>>    kunmap(process_pages[i]);
>>    if (ret)
>>       goto out;
>
> Shouldn't we be using kmap_atomic()

Over a copy_to/from_user? Not bloody likely.

                     Linus
