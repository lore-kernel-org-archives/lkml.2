Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab2FFSy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:54:57 -0400
Received: from relay2.sgi.com ([192.48.179.30]:59990 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757642Ab2FFSyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:54:54 -0400
Date: Wed, 6 Jun 2012 13:54:52 -0500
From: Robin Holt <holt@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Robin Holt <holt@sgi.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Commit 722bc6b167 breaks booting on an 8TB system.
Message-ID: <20120606185452.GR4948@sgi.com>
References: <20120601155447.GG3671@sgi.com>
 <CAE9FiQWJR6x4_Xhc2k5TFkCj2u5cpbcWf-jFWOB5pEuBQcoJrQ@mail.gmail.com>
 <20120604100700.GA4948@sgi.com>
 <CAE9FiQW_yBZZKsVt5Fy7QEqa7hBXhfbka4Ubh=oz4hDOzLQ0mg@mail.gmail.com>
 <20120606094211.GL4948@sgi.com>
 <20120606094804.GM4948@sgi.com>
 <20120606095102.GH9495@gmail.com>
 <CAE9FiQUj3wyzQxtq9yzBNc9u220p8JZ1FYHG7t=MOzJ=9BZMYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQUj3wyzQxtq9yzBNc9u220p8JZ1FYHG7t=MOzJ=9BZMYA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 10:55:40AM -0700, Yinghai Lu wrote:
> On Wed, Jun 6, 2012 at 2:51 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Robin Holt <holt@sgi.com> wrote:
> >>
> >> Wait.  I was wrong.  I booted the wrong kernel.  With that
> >> patch applied, the machine does boot.
> >
> > Great.
> >
> > Could you guys please write a usable changelog for
> > only_need_recalculate_for_low.patch and send it to me with lkml
> > Cc:-ed, so that I can send the fix to Linus ASAP?
> 
> please check attached one.


Your attached patch is the same as the patch I had tested.  I do not
have access to the machine for more than a day to test this actual patch,
but as far as 'diff' can tell, the difference is commit header only.

Robin
