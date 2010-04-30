Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab0D3Uk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:40:59 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60512 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759547Ab0D3Uk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:40:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jfT8gRREUwvm/aGjThatH+cKt+PWkZesiDnxOFpgGqnnrcGBglm4LTLe9bPtRfd4wx
         j6AmK1FglxpIXm3T7KwhkzXnkhBWaYPi6foCgRga8C8CZcGkjZYrgsIrf0UGf5raBEwI
         aBuMfwHjfjZ3Bcx/NbMMwRLYhkX0BDmeFYQMw=
MIME-Version: 1.0
In-Reply-To: <20100430181349.GA1015@oksana.dev.rtsoft.ru>
References: <1272374302-9506-1-git-send-email-dbaryshkov@gmail.com>
	 <20100427154835.27bdc233.akpm@linux-foundation.org>
	 <20100430181349.GA1015@oksana.dev.rtsoft.ru>
Date: Sat, 1 May 2010 00:40:54 +0400
Message-ID: <g2qbc64b4641004301340h3c942f3cn40de735b419b8535@mail.gmail.com>
Subject: Re: [PATCH] Remove tosa_battery driver (was: Re: [PATCH] 
	tosa_battery: fix FTBFS bug due to driver_data access)
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Marek Vasut <marek.vasut@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 30, 2010 at 10:13 PM, Anton Vorontsov
<cbouatmailru@gmail.com> wrote:
> On Tue, Apr 27, 2010 at 03:48:35PM -0700, Andrew Morton wrote:
>> On Tue, 27 Apr 2010 17:18:22 +0400
>> Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:
>>
>> > Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>> > ---
>> >  drivers/power/tosa_battery.c |    4 ++--
>> >  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> Please don't send unchangelogged patches.
>>
>> Please don't send patches which require recipients to go googling
>> acronyms to work out wtf you're up to.
>>
>> <googles the acronym>
>>
>> Ah, it appears to be a build fix.
>
> It seems that the driver isn't buildable since 2.6.32
> (i.e. commit b4028437 "Driver core: move dev_get/set_drvdata to
> drivers/base/dd.c").
>
> Also, IIRC it was deprecated in favor of wm97xx_battery.c
> driver.
>
> So, I'm not picking this patch for 2.6.34, it's not a
> new regression, and the driver is probably needs to be
> removed.
>
> Any objections on the patch down below?

Yes. wm97xx_battery handles only one battery, while tosa uses 3
different batterires.
So, wm97xx_battery needs to be adapted/enhanced.

-- 
With best wishes
Dmitry
