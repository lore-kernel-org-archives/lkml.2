Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1BFLGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 06:06:20 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60578 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab1BFLGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 06:06:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N6wqujCiAEbv2CxNzqsSUs+EGgCeK+gts2KgwRk6/onkDy+Zu7qWEubwGF9MSBaupv
         C5XmCZY4i483DuUgFgssj5OGSKiPhmHIz/sxjaHdLPyerdM6qdvbHzopOzK56u3Vox0L
         ArndwNNfrUoPviX2SIynUHniddlvdweykWuaM=
MIME-Version: 1.0
In-Reply-To: <s5hei7lwhmg.wl%tiwai@suse.de>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
	<20110206081950.GA12659@marc.osknowledge.org>
	<s5hei7lwhmg.wl%tiwai@suse.de>
Date: Sun, 6 Feb 2011 21:06:18 +1000
Message-ID: <AANLkTimURab9M5-LQxU0wjo=gEVBjHyv6osudadq4nNO@mail.gmail.com>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
From: Dave Airlie <airlied@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Marc Koschewski <marc@osknowledge.org>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Chris Wilson <chris@chris-wilson.co.uk>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> I reverted the specified commit and my box still suffers the
>> resume-turns-into-cold-boot behavior. Retried two times with the commit reverted
>> on top of HEAD...
>
> The cold-boot problem is very likely irrelevant with i915 patches.
> I've got the same issue with and without the i915 fix patches on test
> machines here.
>
Yeah its the 32-bit NX stuff most likely if you are using 32-bit kernels.

Dave.
