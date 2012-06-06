Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2FFJvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:51:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53322 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab2FFJvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:51:07 -0400
Date: Wed, 6 Jun 2012 11:51:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robin Holt <holt@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Commit 722bc6b167 breaks booting on an 8TB system.
Message-ID: <20120606095102.GH9495@gmail.com>
References: <20120601155447.GG3671@sgi.com>
 <CAE9FiQWJR6x4_Xhc2k5TFkCj2u5cpbcWf-jFWOB5pEuBQcoJrQ@mail.gmail.com>
 <20120604100700.GA4948@sgi.com>
 <CAE9FiQW_yBZZKsVt5Fy7QEqa7hBXhfbka4Ubh=oz4hDOzLQ0mg@mail.gmail.com>
 <20120606094211.GL4948@sgi.com>
 <20120606094804.GM4948@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606094804.GM4948@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> > With just that patch, no improvement.
> > 
> > Sorry about the delay.  I got bumped from the machine yesterday.
> > The next reservable time is tomorrow night, otherwise, the machine is
> > booked solid for the next 36 hours.
> 
> Wait.  I was wrong.  I booted the wrong kernel.  With that 
> patch applied, the machine does boot.

Great.

Could you guys please write a usable changelog for 
only_need_recalculate_for_low.patch and send it to me with lkml 
Cc:-ed, so that I can send the fix to Linus ASAP?

Thanks,

	Ingo
