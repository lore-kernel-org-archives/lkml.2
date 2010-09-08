Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab0IHVHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:07:17 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47693 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0IHVHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=c88XbXU0N0yLwugc97YtD2cBG0PKfsf2/wwPaWiuV1KlJydOLH4l4QVKK42c/n1o3N
         Y8AlPW0h1wZ6zk7mwiiE3fWpWeeErNFoWz3nBcxZaDZC9iOlO7rKablL/4axzi5BT8Us
         yqoqXXHg+wjVrVYBxu8DAvKZR1C6R2QH9Hp68=
MIME-Version: 1.0
In-Reply-To: <20100908221144.73066e2d@lxorguk.ukuu.org.uk>
References: <fmbxh-5N8-41@gated-at.bofh.it>
	<55BC9463-95B9-4034-AA1E-55042D6E9354@gmail.com>
	<201009081115.15544.hpj@urpla.net>
	<AANLkTi=U40mzeMh-UJJy=ggVDry2qDWW-MYYyBhS_Kex@mail.gmail.com>
	<20100908185605.55671889@lxorguk.ukuu.org.uk>
	<AANLkTi=khD7fSVv_tC6TogimjJshEErj6Em8mCcDF+SM@mail.gmail.com>
	<20100908200715.2e56d0be@lxorguk.ukuu.org.uk>
	<AANLkTi=FNFKmBgobH4q-GHguHM-0UOCQpa7JhPhyZZHG@mail.gmail.com>
	<20100908221144.73066e2d@lxorguk.ukuu.org.uk>
Date: Wed, 8 Sep 2010 22:07:13 +0100
Message-ID: <AANLkTi=YDGV2gd21Ora8YyfGRLC8kEkKzpo+S41VJunw@mail.gmail.com>
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
From: Nick Lowe <nick.lowe@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, you win! :)

Were some form of this patch to be merged in the future, the bintutils
fix is likely to result in it never being hit anyway, so I suppose it
doesn't matter much.
In the long run, it could probably be removed.

I still think it's an incredibly ugly hack! :P

Cheers,

Nick

On Wed, Sep 8, 2010 at 10:11 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> 1) Those enterprise long term distributions aren't going to be
>> targeting the Crusoe or Geode. It's not their market. Would they even
>
> See this is the problem. You've forgotten *users*. It's easy to roll a
> special kernel, its hell on earth
>
>> back port, therefore, if it was an issue?
>> (This hypothetical anyway as it assuming they have an i686 targeted
>> build already. Who does? Centos, RHEL and SUSE Enterprise are all i386
>> targeted at the moment for x86.)
>
> Wrong for some packages - and enough to break things. Bits like glibc for
> example and chunks of X and proprietary apps.
>
>>. (Again, hypothetical, as they're not targeted at i686!)
>
> See above
>
>> 4) As for proprietary apps, again, is it likely that they're targeting
>> i686 already? Or is it far more likely they're compiled for i386 et.
>> al.
>
> Lots used -i686 because the compiler people said its faster and it works
> on all 686 platforms. Neither of which it turns out is exactly true in
> many cases.
>
>> 6) What we are talking about is future distributions, whatever they
>> are, that are now or are changing to target i686 which end users will
>> ultimately want to migrate to and run.
>
> s/we/you
>
> Getting the stuff right in the current kernel makes it easier to backport
> and fix and do tidily. It's not as if NOPL is complicated to emulate.
>
