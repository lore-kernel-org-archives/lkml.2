Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2FFJsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:48:08 -0400
Received: from relay2.sgi.com ([192.48.179.30]:47959 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755429Ab2FFJsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:48:06 -0400
Date: Wed, 6 Jun 2012 04:48:04 -0500
From: Robin Holt <holt@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Robin Holt <holt@sgi.com>, WANG Cong <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Commit 722bc6b167 breaks booting on an 8TB system.
Message-ID: <20120606094804.GM4948@sgi.com>
References: <20120601155447.GG3671@sgi.com>
 <CAE9FiQWJR6x4_Xhc2k5TFkCj2u5cpbcWf-jFWOB5pEuBQcoJrQ@mail.gmail.com>
 <20120604100700.GA4948@sgi.com>
 <CAE9FiQW_yBZZKsVt5Fy7QEqa7hBXhfbka4Ubh=oz4hDOzLQ0mg@mail.gmail.com>
 <20120606094211.GL4948@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606094211.GL4948@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With just that patch, no improvement.
> 
> Sorry about the delay.  I got bumped from the machine yesterday.
> The next reservable time is tomorrow night, otherwise, the machine is
> booked solid for the next 36 hours.

Wait.  I was wrong.  I booted the wrong kernel.  With that patch applied,
the machine does boot.

Thanks,
Robin
