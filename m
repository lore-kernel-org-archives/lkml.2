Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0KKQgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 11:36:35 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62178 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab0KKQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 11:36:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Vk6IPanJE/NntBPNOAZFcDer+PjFgI9XPd8Skl9SUL8D8i572CotKRHHtJ3pbdUY7Q
         fXtMJQmOEvG9YkL5cPDh0jc4mQitxkRtI846LoceMhvfQaKJhEa1ERsGg/fqy+iRkoZZ
         9YMK9KI9VxI0hyTCyCkypUsyfa6jBOBjLh18A=
MIME-Version: 1.0
In-Reply-To: <20101111121917.GA933@kroah.com>
References: <AANLkTikDXtLrfjYkQrkGi44qi0cpp-C+Lxr5j1UkFd2G@mail.gmail.com>
	<20101109224450.GB21992@kroah.com>
	<AANLkTimHOAdUieTzFvNNhaPxwvas2wBDfSL8aPu764HZ@mail.gmail.com>
	<20101110183940.GA15089@kroah.com>
	<AANLkTimTy0vngwuM=jWfeU7qgqznamPgAftX7=2LShL+@mail.gmail.com>
	<20101111121917.GA933@kroah.com>
Date: Thu, 11 Nov 2010 22:36:25 +0600
Message-ID: <AANLkTi=dTW3WA-eLnnaHNcLdVKz7Bn41e8FE=67iVCyJ@mail.gmail.com>
Subject: Re: [PATCH] fs, sysfs: Change sysfs_pathname function prototype.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/10, Greg KH <greg@kroah.com> wrote:
>
> perhaps, yes, that might be correct, but as almost no one builds with
> WARN not enabled, is this a real issue?

I'm trying to find out the config, which causes the warning (it gets
overwritten). Not all config produces the warning. Maybe - it was a
randconfig, which generates the warning. I'll again try some
randconfig and will try to find the config which generates the
warning. If I find something I'll notice. But, I think the issue is
real.



thanks,
rakib

>
> thanks,
>
> greg k-h
>
