Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1BUJFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 04:05:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63313 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab1BUJFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 04:05:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AYjj1P6XWtBH96zGvSRAKrnX8fxkoVSOLEbMCB4Zynz85ojxM1IKLPImQHi04c5Tgl
         6dAK0OjX3dcV0fdT2WlTuUaLDbq7jwwI8iCCU/XRf0xLBufmvcO+m35teAEuRqtcxFIM
         R5LA53cPgqbgZexVmq5QkySCN3bPcWGS/oCmY=
MIME-Version: 1.0
In-Reply-To: <1298258005.7853.2.camel@marge.simson.net>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
	<1298185696-4403-6-git-send-email-yong.zhang0@gmail.com>
	<1298207379.7998.11.camel@marge.simson.net>
	<20110220141003.GA6006@zhy>
	<1298222533.7881.15.camel@marge.simson.net>
	<1298258005.7853.2.camel@marge.simson.net>
Date: Mon, 21 Feb 2011 17:05:33 +0800
Message-ID: <AANLkTi=7gf88Uk5dttACfu71DLLsaF2wBc6=ORdxxj0f@mail.gmail.com>
Subject: Re: [PATCH 5/5] sched, autogroup: runtime enable/disable tuning fix
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 11:13 AM, Mike Galbraith <efault@gmx.de> wrote:
>> Your whole series looked fine to me at a glance (sunday;), with the
>> exception of #2, that one is maybe iffy, depending on point of view.
>
> Hm, my mind wandered off to different file somewhere along the line :)

Never mind :)

If we relax the runtime autogroup switch, maybe patch-2 is a little
overkill, because after autogroup is disabled there still could have
some tasks staying on it's autogroup.
So if we wan to keep current autogroup switch behavior, I think
we can make autogroup_path() independent on
sysctl_sched_autogroup_enabled, thus user will not be confused
by lots of groups named "cfs_rq[*]:"

But if this patch is accepted, IMHO, patch-2 is ok.

Thanks,
Yong


-- 
Only stand for myself
