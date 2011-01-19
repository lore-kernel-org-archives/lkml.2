Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1ASEfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 23:35:48 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38997 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1ASEfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 23:35:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tvQBy1Cd3PTr3s+kR1tb3PNTKIJhhpMQl7+N+0S07BfIhBhcGIPFCSozJFDtXCxJsZ
         sugvIzd6JqnEY4p3gg57RC+taX0So3Zjz6rw3In3KkG8YXLHmJdHimHl35w9F1d0XDnO
         r0kzrrQI4D8t4FPF4V8LaMIsz1zWWOYNiJuQM=
MIME-Version: 1.0
In-Reply-To: <1295408637.8017.56.camel@marge.simson.net>
References: <1295275365.12840.13.camel@kolo>
	<1295280032.30950.128.camel@laptop>
	<1295339012.11678.35.camel@kolo>
	<AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	<1295357746.30950.681.camel@laptop>
	<AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
	<1295408637.8017.56.camel@marge.simson.net>
Date: Wed, 19 Jan 2011 12:35:45 +0800
Message-ID: <AANLkTineieNdiKduDHQ-J+Xv6Pq9O0pTZraBJEw=p5e7@mail.gmail.com>
Subject: Re: Bug in scheduler when using rt_mutex
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, samu.p.onkalo@nokia.com,
        mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 11:43 AM, Mike Galbraith <efault@gmx.de> wrote:
>> (cfs_rq->curr != se) equals to (!running), no?
>
> No, running is task_of(se) == rq->curr.  Another class or fair group
> task may be rq_of(cfs_rq)->curr

If task_of(se) != rq->curr, as you said it maybe on another class or
fair group; then for its fair group, cfs_rq->curr == NULL.
cfs_rq->curr != se is always true.

Thanks,
Yong

-- 
Only stand for myself
