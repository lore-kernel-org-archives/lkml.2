Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab1HJOGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:06:40 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:40208 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1HJOGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:06:38 -0400
Date: Wed, 10 Aug 2011 10:06:29 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Ike Panhc <ike.pan@canonical.com>, linux-kernel@vger.kernel.org,
        mjg@redhat.com, platform-driver-x86@vger.kernel.org
Subject: Re: [RESEND][PATCH 0/5] Support for the TS-5500 board
Message-ID: <20110810100629.715c3bb7@v0nbox>
In-Reply-To: <CAHR064hamS0gHqQR5a5UAanN89CzzW94sjW6SB3=8MAcf6pkMg@mail.gmail.com>
References: <1311887450-22235-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<20110809233208.1a71122e@lenov0n>
	<4E421CD8.3090606@canonical.com>
	<CAHR064hamS0gHqQR5a5UAanN89CzzW94sjW6SB3=8MAcf6pkMg@mail.gmail.com>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le Wed, 10 Aug 2011 08:18:28 +0200,
Corentin Chary <corentin.chary@gmail.com> a écrit :

> On Wed, Aug 10, 2011 at 7:53 AM, Ike Panhc <ike.pan@canonical.com>
> wrote:
> > I think platform-driver-x86 may not be the best mailing list for
> > your patches.
> >
> > Please try to use scripts/get_maintainer.pl and it can tell you who
> > you shall ask for reviewing.
> 
> Like Ike said, this is the mainling list for drivers/platform/x86, not
> arch/x86, and running get_maintainer.pl on your patchs will give you
> the rights people to CC.

Thanks for this information, it can be useful indeed.

> 
> And btw, I'm not sure we really want to put all these drivers in
> arch/x86/platform/ts5500/ a re-create the arm driver mess.
> drivers/leds/, drivers/gpio/  and drivers/mtd/ are probably a best
> choice.

In fact, this set of patches is a rewrite of the first RFC set, where
we discussed that arch/x86/platform/ could be a good place, as the
TS-5500 is a specific platform with its platform devices (the
corresponding thread is here: https://lkml.org/lkml/2011/5/3/60).

Regards,
Vivien.
