Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab0LOOMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:12:52 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:55249 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab0LOOMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:12:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qVmxuVMptr+Hvy4o+y6ttoDgCTKnEZ7aZGqp7QPEYoktbHgLi83c6zjJHNaFX9N9rg
         /I3Pkfu4zavgPIq0BM/drUJ6xmreVwLpS0VWr9jV/+s602d4Hhs8BVEOC+rwM4fK812u
         EuN7pSzzRRPk7VBcWvJXyYRYJSIf+y4qtSwSs=
MIME-Version: 1.0
In-Reply-To: <201012142058.04469.rjw@sisk.pl>
References: <201012130128.31243.rjw@sisk.pl>
	<AANLkTi=UVOQb15EdpfSeD+Qh8x779pJpsSCTyGvf-gxG@mail.gmail.com>
	<AANLkTim+UoR+GeEK8T1_jgie3gwq6Pdt_=sRiSf8qx6K@mail.gmail.com>
	<201012142058.04469.rjw@sisk.pl>
Date: Wed, 15 Dec 2010 22:12:49 +0800
Message-ID: <AANLkTikT-8XjqBfSPAVRZRKp5BQq_D8DeUo2YN3c4ntF@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/4] PM: Remove redundant checks from core device
 resume routines
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/15 Rafael J. Wysocki <rjw@sisk.pl>:
> On Tuesday, December 14, 2010, Ming Lei wrote:

>> Seems it may apply in other cases(dpm_prepare/dpm_suspend
>> /dpm_suspend_noirq) too?
>
> I thought about that, but in these cases the status is changed after the
> callback has returned and only if it's succeeded.  Moreover, if the callback
> hasn't been successful, the device is not moved to the new list, so I think
> it's better to leave that as is.

Yes, you are right, sorry for my noise, :-(


thanks,
-- 
Lei Ming
