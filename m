Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab2AZVYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:24:49 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56549 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2AZVYs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:24:48 -0500
MIME-Version: 1.0
In-Reply-To: <1327472117.7591.12.camel@marge.simson.net>
References: <1324633794.24803.48.camel@twins> <20111223154137.GA27901@redhat.com>
 <20111226172357.CE4D.E1E9C6FF@jp.fujitsu.com> <20111226171151.GA4472@redhat.com>
 <4EFB8523.6080708@gmail.com> <1327400618.2614.13.camel@laptop>
 <4F1EF1E8.4090909@jp.fujitsu.com> <1327472117.7591.12.camel@marge.simson.net>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 26 Jan 2012 16:24:27 -0500
X-Google-Sender-Auth: kLXGLeEg3KYVHjIioM8omgQYHLg
Message-ID: <CAHGf_=oQb=p9m3v6wJpLpF0SqoPnNaJTSWbiMRbrMxZ5WX_6zg@mail.gmail.com>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
To: Mike Galbraith <efault@gmx.de>
Cc: peterz@infradead.org, oleg@redhat.com, y-goto@jp.fujitsu.com,
        mingo@elte.hu, kamezawa.hiroyu@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >>                         task->state = TASK_UNINTERRUPTIBLE;
>> >>                         schedule()
>
> I think you meant:
>        __set_current_state(TASK_UNINTERRUPTIBLE);
>        schedule();
>
> The way you wrote it, task doesn't have to be current, so could be doing
> the bad thing Peter pointed out, diddling *another* tasks ->state.

Silly me. Thank you for following up me.
