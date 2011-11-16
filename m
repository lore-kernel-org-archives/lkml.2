Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab1KPBPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 20:15:16 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49206 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab1KPBPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 20:15:14 -0500
MIME-Version: 1.0
In-Reply-To: <20111115144943.GJ30922@google.com>
References: <20111115083646.GA21468@darkstar.nay.redhat.com>
	<20111115144943.GJ30922@google.com>
Date: Wed, 16 Nov 2011 09:15:12 +0800
Message-ID: <CABqxG0dNoXjpOtug62TLX+as0CAt_niQc=msZTh+heLv8zLQyg@mail.gmail.com>
Subject: Re: [PATCCH percpu: add cpunum param in per_cpu_ptr_to_phys
From: Dave Young <hidave.darkstar@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dave Young <dyoung@redhat.com>, gregkh@suse.de, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 10:49 PM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Nov 15, 2011 at 04:36:46PM +0800, Dave Young wrote:
>> per_cpu_ptr_to_phys iterate all cpu to get the phy addr
>> let's leave the caller to pass the cpu number to it.
>>
>> Actually in the only one user show_crash_notes,
>> cpunum is provided already before calling this.
>>
>> Signed-off-by: Dave Young <dyoung@redhat.com>
>
> Does this matter?  If it's not a performance critical path, I'd rather
> keep the generic funtionality.

Hi, why not? the code is redundant, it's an improvement of the code, isn't it?
Also, kernel code size will be smaller.

>
> Thanks.
>
> --
> tejun
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Regards
Dave
