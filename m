Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1EIMwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 08:52:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54403 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1EIMwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 08:52:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=auPReu9sl8cHgmigqeUuXgXnHdYcUbY4RPFJZHf7OexppWT58jor22m2t9Ky/Pkojl
         /QyHJ+yMFkYkeDwClQu9vIgLCTG51DGbE5LdyZ1valkTGU6Ji0RilxQGAWVkgNZc9N1w
         RvxddunOG93dNHR1QPCN+77GdXvwXl8vorIC8=
MIME-Version: 1.0
In-Reply-To: <BANLkTimjkK-q63x5DrEj+9=pF8zbW7mJ2g@mail.gmail.com>
References: <BANLkTi=tPbwNP3xDYZVHHqQ2zZujCBT6jw@mail.gmail.com>
	<BANLkTimjkK-q63x5DrEj+9=pF8zbW7mJ2g@mail.gmail.com>
Date: Mon, 9 May 2011 20:52:53 +0800
Message-ID: <BANLkTimrHnX5BcK5Q6eJgCAzP+j7azAqow@mail.gmail.com>
Subject: Re: [PATCH] sched: shorten setting the allowed cpu mask of task
From: Hillf Danton <dhillf@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 12:39 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Fri, May 6, 2011 at 8:52 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> When setting the allowed cpu mask for a given task, if the task is
>> already bound to certain cpu, after checking the validity of the new
>
> Maybe we don't need to restrict it only on task bound to certain cpu.
>
Hi Yong

The original code guards, I guess, casual change in the mask of
allowed CPUs, if bounded,
for tasks such as the workers of work queue. So the restriction looks necessary.

thanks
          Hillf
