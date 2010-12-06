Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0LFS47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:56:59 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41738 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab0LFS45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:56:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=V9IYf0HQUzXLc5vs5krZ2DyL0NkisXyuzUdB1r1YsvRc2kcntFbW4QFluYycieHzT5
         Dd6DBDA+XpUw6fgjuQieB5mPNxEQtizK7WF5DLsGjSoeHAqQIsGEAJJjqZ/FfAqywOxH
         RCCrietVdm6L7ticnx1B2BFNm/CWfW1pGMJ2Q=
MIME-Version: 1.0
In-Reply-To: <4CFD258B.4030604@oracle.com>
References: <20101204135732.GA12774@sepie.suse.cz>
	<AANLkTimeyo==XJWUaUs8EzJvA8azkk3sw9FXQhMjuo6M@mail.gmail.com>
	<20101205081108.9bdb7504.randy.dunlap@oracle.com>
	<AANLkTimm1Xn4wwNAoDJ4hjnOmBOnxBgcsCzVEJTEag97@mail.gmail.com>
	<AANLkTimXRBz7-mz_E_xdc85pGi7ExMy67XfDVF7jEt+Y@mail.gmail.com>
	<4CFD258B.4030604@oracle.com>
Date: Mon, 6 Dec 2010 13:56:56 -0500
Message-ID: <AANLkTi=uMk74hYa-2aoVgj-F1h=+zGC2T=m4i__OwwQM@mail.gmail.com>
Subject: Re: [GIT] kbuild and kconfig fixes for 2.6.37-rc5
From: Arnaud Lacombe <lacombar@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, trapdoor6@gmail.com,
        Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        brueckner@linux.vnet.ibm.com, mchehab@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 6, 2010 at 1:03 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On 12/06/10 10:01, Catalin Marinas wrote:
> [...]
>> This could be simplified to only show the first option of every '&&'
>> expression, something like below:
>>
>> warning: I2C_ISCH selects MFD_CORE...
>> warning: GPIO_SCH selects MFD_CORE...
>>
>> But I couldn't figure out whether the expression reduction code in
>> kbuild reorders the options or not.
>
This was the purpose of a patch I send a month or two ago, though, you
defeated it with cases the code was not taking into account. I updated
it since, but did not post it. I'll post it on linux-kbuild@ and
continue the discussion there.

> I'm pretty sure that I have seen cases where the faulty kconfig is not the
> first one listed, so all of them need to be available.
>
do you have an example ?

Thanks,
 - Arnaud
