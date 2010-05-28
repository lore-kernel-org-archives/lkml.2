Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0E1FoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 01:44:21 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59260 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab0E1FoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 01:44:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xDNDkEs36iRAF1J885+KhuzFYnLEayb6wDTHwXEdHMabXdEjYPJ/C2ssByTGFvK9tn
         /64XsWGc282akGAQxaI/l2n711ivwUxUsZtggXEQChPJ8aQxtzAW8RKPfETAupcru1UO
         EwHUBvg5PqEV/nbTkbpdm6RxsMc/lR/RQQtgs=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1005272108210.11382@i5.linux-foundation.org>
References: <20100520165243.GA20861@core.coreip.homeip.net>
	<alpine.LFD.2.00.1005271837050.11382@i5.linux-foundation.org>
	<AANLkTiklv48cDWNqKlFfh5RVtxxNH8shH_JjDypPgeHA@mail.gmail.com>
	<alpine.LFD.2.00.1005272108210.11382@i5.linux-foundation.org>
Date: Fri, 28 May 2010 15:44:18 +1000
Message-ID: <AANLkTinPt49coLNjPqJSSxDP8zTmnjbKuIP1NuQFvwL-@mail.gmail.com>
Subject: Re: [git pull] Input updates for 2.6.35-rc0
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Ragwitz <rafl@debian.org>, Arjan Opmeer <arjan@opmeer.net>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, peter.hutterer@who-t.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 2:12 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 28 May 2010, Dave Airlie wrote:
>>
>> Was this in GNOME?
>>
>> Does System->Preferences->Mouse have a touchpad tab? do it have tapping off?
>
> Bingo! Yup, that turns a totally useless piece-of-crap touchpad into a
> perfectly cromulent one!
>
> Too bad that the default behavior made it act so horribly bad.
>

I've cc'ed Peter, but I think thats the GNOME default behaviour, which
might make sense for
older style touchpads, but maybe not for these newer the touchpad is a
button type.

Dave.
