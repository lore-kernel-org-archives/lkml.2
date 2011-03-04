Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab1CDDnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 22:43:18 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58832 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab1CDDnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 22:43:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wKGVeue6s2vsFj+5ajmDsvY72BuEjHJy0AlBg8dVYZVlzraPjQ3vAp6TYdalNhu546
         Uki9y8DNVo0WtR6TTsquCHhl0yzVXVNqe5f3kUjqvxFQ+Q0zLCVbumzWidGtT4J7Dmzn
         17QW08H9T3WLgWW0/mJsfUcKHzVlwAVwAd0cw=
MIME-Version: 1.0
In-Reply-To: <AANLkTikHFLoJOZvx2YebKdHt+jjiHgUFasiLTrZ6vBUJ@mail.gmail.com>
References: <20110303113435.GA2868@balbir.in.ibm.com>
	<20110303140551.GA20677@zhy>
	<AANLkTikHFLoJOZvx2YebKdHt+jjiHgUFasiLTrZ6vBUJ@mail.gmail.com>
Date: Fri, 4 Mar 2011 11:43:16 +0800
Message-ID: <AANLkTikqC=MNXXavJ_jxhFNQz1uNdABXVhvj82HW=BNA@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] Fix sched rt group scheduling when hierachy is enabled
From: Yong Zhang <yong.zhang0@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <pzijlstr@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Bharata B Rao <bharata.rao@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 11:29 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> No, not really :) It is required, it is a backup check to see if we
> have queued tasks, rt_time of 0 and the runqueue is not throttled, why
> should it be dequeued?

But I can't see where that kind of rt_rq is dequeued, mind pointing it out?

Thanks,
Yong

-- 
Only stand for myself
