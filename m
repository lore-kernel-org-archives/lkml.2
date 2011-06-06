Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab1FFNO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:14:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34218 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab1FFNO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:14:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CVjFG+3sR+DVlQzpe9Z8urafft87+Up2azUamQOApNWMQvXXzntzfvzbfw/sr81CAH
         DcD4ru7ScPC0CTyis8EIlg3AphRJOac3fpuyAosw6ARNR3M03jWxeNcMENSduFfhQqTK
         nJ/flSal69m5AsvIgis2GNpW5ImFHMk6QjdGI=
MIME-Version: 1.0
In-Reply-To: <1307359563.31814.14.camel@gandalf.stny.rr.com>
References: <BANLkTin1QYAx7as41t78-n0giLSBWoToVA@mail.gmail.com>
	<BANLkTi=N8cm_9OKk8VCPVxPPn+Ejuhzq6w@mail.gmail.com>
	<BANLkTinO4p5d-aShHuSOQoPLTCZvAcVjcQ@mail.gmail.com>
	<1307359563.31814.14.camel@gandalf.stny.rr.com>
Date: Mon, 6 Jun 2011 21:14:56 +0800
Message-ID: <BANLkTinCbAhE_Zkf393wbtqwu5L0U2jU7w@mail.gmail.com>
Subject: Re: [PATCH] sched: remove noop in pre_schedule_rt()
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 7:26 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-06-06 at 16:35 +0800, Hillf Danton wrote:
>> On Fri, May 27, 2011 at 5:17 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
>> > On Thu, May 26, 2011 at 9:08 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> >> Checking task to be RT is removed since only RT task is served here.
>> >>
>> >> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> >
>> > Actually this patch has been raised for two times:
>> > https://lkml.org/lkml/2010/12/13/622
>> > http://lkml.org/lkml/2010/2/9/139
>> >
>>
>> Hm... looks curious why it had been delivered more than once.
>
> What's curious about it?
>

Hi Steve

The work was repeated not only by Yong, you see, almost
impossible, which shows RT scheduling was and is
attracting minds, and will be as well, right?

thanks
          Hillf
