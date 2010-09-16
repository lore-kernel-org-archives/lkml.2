Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0IPCZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 22:25:13 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:50741 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab0IPCZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 22:25:12 -0400
Date: Thu, 16 Sep 2010 11:55:07 +0930
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Cross Memory Attach
Message-ID: <20100916115507.32dd9238@lilo>
In-Reply-To: <AANLkTikak7E1otZ3Uffiz2hRvOGrPe6kLcDp3tM69QM_@mail.gmail.com>
References: <20100915104855.41de3ebf@lilo>
	<AANLkTimNsDxeyZL4GVaH4L7YGO-EoRyCMHDtMPWU37hN@mail.gmail.com>
	<AANLkTikak7E1otZ3Uffiz2hRvOGrPe6kLcDp3tM69QM_@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 08:14:49 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> In fact, you might consider passing in a "copy_out" function pointer
> rather than that "copy_to" boolean, and rather than that conditional,
> just do a
> 
>   ret = copy_out(..);
> 
> thing. On sane/good architectures, branch target prediction will make
> it all work out to the same work in the end, and it certainly looks
> simpler and cleaner.

Thanks for all the feedback - I'll rework the patch...

Regards,

Chris
-- 
cyeoh@au.ibm.com
