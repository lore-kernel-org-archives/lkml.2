Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1HJLtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 07:49:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43213 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab1HJLtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 07:49:07 -0400
Date: Wed, 10 Aug 2011 19:48:50 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] lockdep: Fix wrong assumption in
 match_held_lock
Message-ID: <20110810114850.GA3885@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1312547787.28695.2.camel@twins>
 <tip-80e0401e35410a69bfae05b454db8a7187edd6b8@git.kernel.org>
 <20110810025845.GA5640@zhy>
 <1312970470.23660.3.camel@twins>
 <20110810114550.GA3811@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110810114550.GA3811@zhy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 07:45:50PM +0800, Yong Zhang wrote:
> On Wed, Aug 10, 2011 at 12:01:10PM +0200, Peter Zijlstra wrote:
> > On Wed, 2011-08-10 at 10:58 +0800, Yong Zhang wrote:
> > 
> > > > Link: http://lkml.kernel.org/r/1312547787.28695.2.camel@twins
> > > 
> > > BTW, I can't open this link.
> > 
> > Gah! I did mess that up, but I've no idea how though, I usually
> > copy/paste or let my script do it, in case of copy/paste one would
> > assume I picked the wrong msg, but a grep through my sent folder doesn't
> > find any email with that msgid.. and my script isn't imaginative enough
> > to  just make one up like that. Anyway:
> > 
> >   lkml.kernel.org/r/1312969382.23148.1.camel@twins
> > 
> > should be the actual link, however that doesn't appear to work either,
> > included the relevant headers of the actual email:
> > 
> > ---
> > 
> > Subject: Re: select_task_rq_fair: WARNING: at kernel/lockdep.c match_held_lock
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, 
> >  Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
> >  KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
> > Date: Fri, 05 Aug 2011 14:36:20 +0200
> > In-Reply-To: <20110804155347.GB3562@swordfish.minsk.epam.com>
> > References: <20110804141306.GA3536@swordfish.minsk.epam.com>
> >          <1312470358.16729.25.camel@twins>
> >          <20110804153752.GA3562@swordfish.minsk.epam.com>
> >          <1312472867.16729.38.camel@twins>
> >          <20110804155347.GB3562@swordfish.minsk.epam.com>
> > 
> > Message-ID: <1312969382.23148.1.camel@twins>
> 
> The actual one showed in maillist is like below:

Hmm, you have mentioned it :)

> ---
> Subject: Re: select_task_rq_fair: WARNING: at kernel/lockdep.c
>  match_held_lock
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
>         Andrew Morton <akpm@linux-foundation.org>,
>         linux-kernel@vger.kernel.org,
>         KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
>         linux-mm@kvack.org
> Date: Fri, 05 Aug 2011 14:36:20 +0200
> In-Reply-To: <20110804155347.GB3562@swordfish.minsk.epam.com>
> References: <20110804141306.GA3536@swordfish.minsk.epam.com>
>          <1312470358.16729.25.camel@twins>
>          <20110804153752.GA3562@swordfish.minsk.epam.com>
>          <1312472867.16729.38.camel@twins>
>          <20110804155347.GB3562@swordfish.minsk.epam.com>
> Content-Type: text/plain; charset="UTF-8"
> Content-Transfer-Encoding: 8BIT
> X-Mailer: Evolution 3.0.2- 
> Message-ID: <1312547780.28695.1.camel@twins>
> ---
> 
> Not sure how the difference happens.
> 
> Thanks,
> Yong
