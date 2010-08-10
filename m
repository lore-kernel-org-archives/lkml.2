Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab0HJIjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 04:39:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53599 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab0HJIjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 04:39:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=kd9j499PmZGdCiRsZ581w67oUjNboZgFuO/17fHALWkQvvCB7esUMuUsv8F+ErJMHj
         T+wETXiAihakLm6YSewO1CQ0RnxXq2O9JGXmKAXdoCdT4O0WAhR9MPyH3H/QVzUAIm1f
         z5YP+UhQW2SdtJt3p3M1K12kxyf6aKnEpying=
MIME-Version: 1.0
In-Reply-To: <1281411152.1670.24.camel@leonhard>
References: <1281411152.1670.24.camel@leonhard>
From: Pistis Valentino <vale.pistis@gmail.com>
Date: Tue, 10 Aug 2010 10:39:21 +0200
Message-ID: <AANLkTinKnLoJUBX5884QkRrDcYiKT=bYJ1zN=a8VSAWy@mail.gmail.com>
Subject: Re: find_task_by_pid() problem
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/10 Namhyung Kim <namhyung@gmail.com>:
>> I'm using the routine find_task_by_vpid () linux / sched.h (the oldest
>> find_task_by_pid() don't exist), but when I try to compile the file I
>> hello_world.c returns an error:
>
> You can only use kernel's EXPORTed symbol, ie. EXPORT_SYMBOL*(), when you
> write a module program because kernel links it on its own way.
> Try this instead.
>
> pid_task(find_vpid(...), PIDTYPE_PID)
>
Great!
It works!

pid_task(find_vpid(pid), PIDTYPE_PID);

> --
> Regards,
> Namhyung Kim
>
>
>

Thank you!
Ciao
Valentino from Sardegna!
