Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab1DZRHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 13:07:21 -0400
Received: from relay1.sgi.com ([192.48.179.29]:46791 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306Ab1DZRHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 13:07:17 -0400
Message-ID: <4DB6FBC2.7000806@sgi.com>
Date: Tue, 26 Apr 2011 10:07:14 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memblock: add error return when CONFIG_HAVE_MEMBLOCK
 is not set
References: <20110425181136.055235992@gulag1.americas.sgi.com>	<20110425181136.211858618@gulag1.americas.sgi.com> <20110425154835.7d41d89e.akpm@linux-foundation.org>
In-Reply-To: <20110425154835.7d41d89e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Mon, 25 Apr 2011 13:11:37 -0500
> Mike Travis <travis@sgi.com> wrote:
> 
>> 	Add an error return if CONFIG_HAVE_MEMBLOCK is not set instead
>> 	of having to add #ifdef CONFIG_HAVE_MEMBLOCK around blocks of
>> 	code calling that function.
>>
>> Authored-by: Yinghai Lu <yinghai@kernel.org>
>> Signed-off-by: Mike Travis <travis@sgi.com>
> 
> There is no such thing as "Authored-by:".  If this patch was written by
> yinghai then it must be tagged as From:him at the top of the changelog
> and preferably has his signed-off-by: at the end.
> 
> Please clarify?

Yes, you have it correct.  I had added the From: line but when I receive
the email, it's removed.

Why not have an "Authored-by"?  That would eliminate the sendmail program
from screwing it up?

Thanks,
Mike
