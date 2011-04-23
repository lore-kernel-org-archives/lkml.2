Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1DWObo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 10:31:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53122 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab1DWObn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 10:31:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LnDGbh5ep8ipL3mhJA375tMwpoxVC3KWDO78RGUaz3pVVpNvLhBIV+VvRJH2evgafI
         2fuk1Eh6wG3ZdxlsDKslXfNOY0QUIQq2RM/TTpU1wtiGlBPqbCFfVP1DhzxJg/P4Iv8k
         5YzypDkehLPVbLE1Mvxaeet9/pxymolnxibsA=
Date: Sat, 23 Apr 2011 22:31:28 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: try to rewrite tg_has_rt_tasks()
Message-ID: <20110423143128.GC7747@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <BANLkTimyN49J0UTo69Rabppeow9Fz-LcfQ@mail.gmail.com>
 <20110423141113.GA7747@zhy>
 <BANLkTi=DqsxwrWhh-FxcdvvJ0cjemHp3sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BANLkTi=DqsxwrWhh-FxcdvvJ0cjemHp3sw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 10:19:19PM +0800, Hillf Danton wrote:
> On Sat, Apr 23, 2011 at 10:11 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> > On Sat, Apr 23, 2011 at 09:39:40PM +0800, Hillf Danton wrote:
> >> It is reshuffled not based upon scanning the list of existing threads
> >> but upon the relevant info carried by the input task group. Compared
> >> with the original, it is simpler, and nothing important is missed.
> >
> > Oh, no.
> >
> > There may be sleep task which is attach this group.
> >
> 
> Would you please say a few more words about the "sleep task"?

Only RUNNING task is counted to rt_nr_running, SLEEP task
is not on the run queue.

Thanks,
Yong
