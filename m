Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab0IHTpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 15:45:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35550 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab0IHTo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 15:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=a7IoL/f5rts97P9KPkWcwvMeTkNYU7GwRywbkV0vlm6WbG2MJSwSCfLZO00CqTs0Lk
         z+i1OWeQQ60pJq+mA90Wf+exd4kMEWeORjbzUfYrvIz0fLTgyhpSV8036EipzvmuipdJ
         Famezn6mYt6p+AH2lWCqXpHx30oN5l9jBFtnY=
MIME-Version: 1.0
In-Reply-To: <20100908200715.2e56d0be@lxorguk.ukuu.org.uk>
References: <fmbxh-5N8-41@gated-at.bofh.it>
	<55BC9463-95B9-4034-AA1E-55042D6E9354@gmail.com>
	<201009081115.15544.hpj@urpla.net>
	<AANLkTi=U40mzeMh-UJJy=ggVDry2qDWW-MYYyBhS_Kex@mail.gmail.com>
	<20100908185605.55671889@lxorguk.ukuu.org.uk>
	<AANLkTi=khD7fSVv_tC6TogimjJshEErj6Em8mCcDF+SM@mail.gmail.com>
	<20100908200715.2e56d0be@lxorguk.ukuu.org.uk>
Date: Wed, 8 Sep 2010 20:44:58 +0100
Message-ID: <AANLkTi=FNFKmBgobH4q-GHguHM-0UOCQpa7JhPhyZZHG@mail.gmail.com>
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
From: Nick Lowe <nick.lowe@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's still not making any sense to me what-so-ever. And I'm really
trying to be open minded!

1) Those enterprise long term distributions aren't going to be
targeting the Crusoe or Geode. It's not their market. Would they even
back port, therefore, if it was an issue?
(This hypothetical anyway as it assuming they have an i686 targeted
build already. Who does? Centos, RHEL and SUSE Enterprise are all i386
targeted at the moment for x86.)

2) Nor is it likely, considering their focus, that end users will want
to run them on their Crusoe or Geode hardware if they were i686
targeted. (Again, hypothetical, as they're not targeted at i686!)

3) Distributions that specifically target the Crusoe or Geode already,
by definition, won't be using an i686 targeted build at the moment.

4) As for proprietary apps, again, is it likely that they're targeting
i686 already? Or is it far more likely they're compiled for i386 et.
al.

5) If they are targeting i686 already, end users won't have been able
to run them on their Crusoe or Geode hardware before so they're not
going to miss them now.

6) What we are talking about is future distributions, whatever they
are, that are now or are changing to target i686 which end users will
ultimately want to migrate to and run.
Again, at the moment, most are i386 targeted, so they all work regardless.
(They'll need to recompile everything anyway if they decide to move,
so it's completely moot surely...)

Thanks,

Nick

On Wed, Sep 8, 2010 at 8:07 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> And nobody has answered what happens when NOPLs are used to
>> synchronise with something else? Surely that can lead to subtle, hard
>> to debug breakage? Isn't that plain worse than refusing to run or
>> breaking out of execution?
>
> NOPL for synchronisation - of user space. I'd say thats sufficiently
> unlikely not to care. It's still an improvement on crashing.
>
> The other point you make is a good one but it's not clear that all the
> proprietary apps for example will get recompiled, so to many users its
> not a solution. Similarly the long term stable distros aren't going to
> recompile everything and invalidate all their test data, so I doubt that
> things like Centos will.
>
> Alan
>
