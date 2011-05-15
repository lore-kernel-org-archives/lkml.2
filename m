Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab1EOR7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:59:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53698 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1EOR7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YczYx/M6WVGjiL+QIqltQr4Ndutvauu5h+ZvcnS2SCZZ0UhhpgpDyaXmAio/gVXG+e
         yCntsrmj2DB/UZ0WHHZeRrPJc/bmq2asrEqR3jsBzK5eL/vvQYSo6kvOtZjNV/2BSu89
         /j1d3MT3AWQ+sNXFpSqFh1QOIf1cIrtx58Bc4=
MIME-Version: 1.0
In-Reply-To: <20110515173644.GA18241@kroah.com>
References: <1305040215-712-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
	<BANLkTinAtUQ8H1DQpqXxX_U4mLO617L3Eg@mail.gmail.com>
	<20110515163257.GE1315@kroah.com>
	<BANLkTi=hN6NeLdXAjzeeYwcZR7+BoJ1BQg@mail.gmail.com>
	<20110515173644.GA18241@kroah.com>
Date: Sun, 15 May 2011 19:59:51 +0200
X-Google-Sender-Auth: 9xMz9dHj3w840f6EHRz-2IxYqDs
Message-ID: <BANLkTinXhc+gRAWVrC--EdrbPjC6U8roYA@mail.gmail.com>
Subject: Re: [PATCH v6] Add ST-Ericsson CG2900 driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg KH <greg@kroah.com>
Cc: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>,
        devel@driverdev.osuosl.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Vitaly Wool <vitalywool@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@sify.com>,
        Lee Jones <lee.jones@linaro.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/15 Greg KH <greg@kroah.com>:
> On Sun, May 15, 2011 at 07:29:04PM +0200, Linus Walleij wrote:
>> It was my recommendation to put it into staging, by doing this
>> people can talk about the architecture by submitting *patches*
>> to show how they want it instead of these fruitless discussions.
>>
>> So this should be a case where staging really helps, at least in
>> my dreams.
>
> Yes, that is where staging should help, hopefully we can get these build
> dependancies worked out to get this merged properly.  Perhaps for the
> .41 merge window?

Since one of the build dependencies is the GPIO rework that already
needed to be pushed from 2.6.40 to 2.6.41 due to shortage of
review power for drivers/gpio, and since I cannot merge the updates
to the current GPIO driver in arch/arm/plat-nomadik/gpio.c due to
the current ban on anything that grows arch/arm/* we will likely
have to postpone its merging to staging to 2.6.42.

Basically this driver has ended up in cross-subsystem dependency
hell :-)

But worse things have happened, and these are special times,
so let's let it rest for a while.

Linus Walleij
