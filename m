Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1DWOTV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 10:19:21 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50929 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab1DWOTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 10:19:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JYysfyzKp53+FItSZyO/WkzXFZbbsc6oNN1qE03ANmVuPtzbNUo2mqvGb7D6GBj/+Z
         7EammCXiUe90mYsUGggL4c5o+m+LL51HRZz4yuwftqE7u6G901bHunnEG3tiQRBp0GcX
         aDORRqui8dQmfAn3RFLvEVxySkMzWVwggbl0A=
MIME-Version: 1.0
In-Reply-To: <20110423141113.GA7747@zhy>
References: <BANLkTimyN49J0UTo69Rabppeow9Fz-LcfQ@mail.gmail.com>
	<20110423141113.GA7747@zhy>
Date: Sat, 23 Apr 2011 22:19:19 +0800
Message-ID: <BANLkTi=DqsxwrWhh-FxcdvvJ0cjemHp3sw@mail.gmail.com>
Subject: Re: [PATCH] sched: try to rewrite tg_has_rt_tasks()
From: Hillf Danton <dhillf@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 10:11 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Sat, Apr 23, 2011 at 09:39:40PM +0800, Hillf Danton wrote:
>> It is reshuffled not based upon scanning the list of existing threads
>> but upon the relevant info carried by the input task group. Compared
>> with the original, it is simpler, and nothing important is missed.
>
> Oh, no.
>
> There may be sleep task which is attach this group.
>

Would you please say a few more words about the "sleep task"?

Thanks
           Hillf
