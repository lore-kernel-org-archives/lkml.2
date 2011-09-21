Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab1IUPzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:55:03 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39299 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1IUPzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:55:01 -0400
MIME-Version: 1.0
In-Reply-To: <20110921131052.GG17169@n2100.arm.linux.org.uk>
References: <E1Qvo1q-0000qv-TQ@rmk-PC.arm.linux.org.uk>
	<1314559619-19923-1-git-send-email-peterhuewe@gmx.de>
	<CACRpkdb=Bt2j4iMV5NJHmPG8wDi6__CRD6kn_KOoaQ1R6uwrWQ@mail.gmail.com>
	<CACRpkdbsUMCvBofKjExiB2wCbK9CwpcXr5xmShJ4SHEGAAH4Bw@mail.gmail.com>
	<20110921131052.GG17169@n2100.arm.linux.org.uk>
Date: Wed, 21 Sep 2011 17:54:59 +0200
Message-ID: <CACRpkdZio+Xpr6Q+E2Sf5juBDRXUPM5Vjx6GqDg66RDNiFvj3A@mail.gmail.com>
Subject: Re: [PATCH] spi: Fix builderror in spi-pl022.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, Peter Huewe <peterhuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 3:10 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Sep 20, 2011 at 10:45:41PM +0200, Linus Walleij wrote:

>> > Grant can you please apply this patch? Right now linux-next is
>> > breaking because of this missing patch...
>>
>> Ping on this... ignore if it's been picked already.
>
> Isn't it already fixed?  I've had this in my tree for quite some time
> (since 5th September) which should also be in linux-next.

It is, just wasn't getting my linux-next right after all the kernelorg
downtime.

Thanks Russell, and sorry for the fuzz.

Yours,
Linus Walleij
