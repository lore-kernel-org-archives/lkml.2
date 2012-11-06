Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2KFAOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 19:14:42 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54969 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab2KFAOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 19:14:40 -0500
MIME-Version: 1.0
In-Reply-To: <1352129116.16194.10.camel@joe-AO722>
References: <1352115282-8081-1-git-send-email-yamanetoshi@gmail.com>
	<20121105131108.GC27238@kroah.com>
	<1352128271.16194.8.camel@joe-AO722>
	<20121105152231.GA4807@kroah.com>
	<1352129116.16194.10.camel@joe-AO722>
Date: Tue, 6 Nov 2012 09:14:39 +0900
Message-ID: <CAOTypNTcAbteTS-ZEqBHLCc0Wa898jd8aLYdCHCxfxnendGcTg@mail.gmail.com>
Subject: Re: [PATCH] staging/media: Use dev_ printks in go7007/s2250-loader.c
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, elezegarcia@gmail.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 12:25 AM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2012-11-05 at 16:22 +0100, Greg Kroah-Hartman wrote:
>> On Mon, Nov 05, 2012 at 07:11:11AM -0800, Joe Perches wrote:
>> > On Mon, 2012-11-05 at 14:11 +0100, Greg Kroah-Hartman wrote:
>> > > On Mon, Nov 05, 2012 at 08:34:42PM +0900, YAMANE Toshiaki wrote:
>> > > > fixed below checkpatch warnings.
>> > > > - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
>> > > > - WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
>> > > >
>> > > > Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
>> > > > ---
>> > > >  drivers/staging/media/go7007/s2250-loader.c |   35 ++++++++++++++-------------
>> > > >  1 file changed, 18 insertions(+), 17 deletions(-)
>> > >
>> > > Please note that I don't touch the drivers/staging/media/* files, so
>> > > copying me on these patches doesn't do anything :)
>> >
>> > Maybe:
>> >
>> >  MAINTAINERS |    1 +
>> >  1 files changed, 1 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/MAINTAINERS b/MAINTAINERS
>> > index b062349..542a541 100644
>> > --- a/MAINTAINERS
>> > +++ b/MAINTAINERS
>> > @@ -6906,6 +6906,7 @@ T:    git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
>> >  L: devel@driverdev.osuosl.org
>> >  S: Supported
>> >  F: drivers/staging/
>> > +X: drivers/staging/media/
>>
>> Sure, that would be good, care to resend it with a signed-off-by: so I
>> can apply it?
>
> It was just a nudge.
>
> You're the nominal staging maintainer, if you choose not to
> work on a specific directory under staging, I think you can
> mark it in MAINTAINERS just as easily yourself.

Thanks for all.

I wait Mauro-san will pick the patches.
And I will send the patches to the correct destination from the next time.


-- 

Regards,

YAMANE Toshiaki
