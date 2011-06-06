Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab1FFIgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:36:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36923 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab1FFIfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:35:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hdUjKgO9nqz22EyQ1lz18N5DlOdAJLS+FL3wgx1Oj6lR/UcGed4/elNjWBTHD3S6Go
         CUgWhLN25W89cmpidRW5o18F7cQ4/VU2hE0OK5/L43k4mR6lz2JlyghgAIe7XV5qhEuX
         q6zgJIdw/Nz1APEp5DDWDb7h+rsURvwaQX5m8=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=N8cm_9OKk8VCPVxPPn+Ejuhzq6w@mail.gmail.com>
References: <BANLkTin1QYAx7as41t78-n0giLSBWoToVA@mail.gmail.com>
	<BANLkTi=N8cm_9OKk8VCPVxPPn+Ejuhzq6w@mail.gmail.com>
Date: Mon, 6 Jun 2011 16:35:51 +0800
Message-ID: <BANLkTinO4p5d-aShHuSOQoPLTCZvAcVjcQ@mail.gmail.com>
Subject: Re: [PATCH] sched: remove noop in pre_schedule_rt()
From: Hillf Danton <dhillf@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 5:17 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Thu, May 26, 2011 at 9:08 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> Checking task to be RT is removed since only RT task is served here.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>
> Actually this patch has been raised for two times:
> https://lkml.org/lkml/2010/12/13/622
> http://lkml.org/lkml/2010/2/9/139
>

Hm... looks curious why it had been delivered more than once.
