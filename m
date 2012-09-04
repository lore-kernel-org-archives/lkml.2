Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab2IDVhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:37:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503Ab2IDVh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:37:27 -0400
Date: Tue, 4 Sep 2012 18:37:08 -0300
From: Flavio Leitner <fbl@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
        ianfang.cn@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kexec/kdump kernel fails to start
Message-ID: <20120904183708.5f10fbde@obelix.rh>
In-Reply-To: <CAE9FiQWnz-pC3ODOfKo6jumGztd1MdypXB5PG-eDrAfTb1s_xQ@mail.gmail.com>
References: <20120904143215.5bbbb2a4@obelix.rh>
	<CAE9FiQUEHbDySWHWFj6kW=HGLR0vkbaJWRq+7kMMHGhBm8e08A@mail.gmail.com>
	<20120904161737.358d51ad@obelix.rh>
	<CAE9FiQX7OMdFU6FuTQdz+NdbNt5Hy9zjzSY7y-90G4CbhayfaA@mail.gmail.com>
	<20120904172639.0c2bfd6d@obelix.rh>
	<CAE9FiQWnz-pC3ODOfKo6jumGztd1MdypXB5PG-eDrAfTb1s_xQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2012 13:45:23 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> On Tue, Sep 4, 2012 at 1:26 PM, Flavio Leitner <fbl@redhat.com> wrote:
> >
> > Sorry, but it didn't work.
> > The same problem happened.
> 
> can you send out boot log ?

sure, there you go:
http://sysclose.org/kdump/dmesg-debug.log
http://sysclose.org/kdump/config.log

fbl
