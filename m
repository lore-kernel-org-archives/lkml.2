Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1CKBex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 20:34:53 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46824 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab1CKBew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 20:34:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=r/PIaqlY1z24CsyakDyIpOqXc2TsjnSYWzRdmPpd4RxUCu/Vx67Fq0/jT5V+VxRd67
         T3Woj8C4K/byJPzztBp6YtNMYJ/6ybIJTil6/RbiF4widlany3IGV+N98grqhHfBVx1n
         PS8hanwC9NvTADkmLHIEgkFVU2KSTUbP8k9dI=
MIME-Version: 1.0
In-Reply-To: <20110310170508.1a3d431d.akpm@linux-foundation.org>
References: <20110216200734.GA25184@merkur.ravnborg.org> <1298062040-2774-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110310164100.5af81e3b.akpm@linux-foundation.org> <AANLkTik7HwLs8Ux=THRy_-ByH4adebHodSLeEgSSqcsH@mail.gmail.com>
 <20110310170508.1a3d431d.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 10 Mar 2011 20:34:31 -0500
Message-ID: <AANLkTikVi7M8+ys1KaQH9JdR8xP_G1KaadbNHgxspe2D@mail.gmail.com>
Subject: Re: [PATCH] kbuild: reenable section mismatch analysis
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 20:05, Andrew Morton wrote:
> On Thu, 10 Mar 2011 20:00:54 -0500 Mike Frysinger wrote:
>> > eaaaargh! __650 lines of crap added to my i386 allmodconfig build output.
>>
>> and it's going to keep staying all f-ed up until people start seeing
>> this stuff themselves when they write the bad code
>
> That won't work - everyone will either disable the messages or will
> train themselves to ignore them.

the status quo is obviously not working.  i spent quite a bit of time
in the past to get the warnings down to 0 for my builds and all ive
seen since then is the # creep back up.  if people arent being made
aware of the issue, they obviously arent going to do anything about
it.  some people might condition themselves to ignore it, but that
applies to any sort of warning message.
-mike
