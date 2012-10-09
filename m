Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab2JISCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:02:54 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54118 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab2JISCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:02:49 -0400
MIME-Version: 1.0
In-Reply-To: <20121009164614.GA17274@kroah.com>
References: <1349799055-4496-1-git-send-email-mujeeb.adil@gmail.com>
	<1349799738.2386.1.camel@joe-AO722>
	<20121009164614.GA17274@kroah.com>
Date: Tue, 9 Oct 2012 23:32:48 +0530
Message-ID: <CANBXnMk_cmDXgMfTbfo0bt6-m5V7GL09-PPUbZAW+5WOAZuXCA@mail.gmail.com>
Subject: Re: [PATCH] Staging: winbond: wbusb: Fixed coding style issue
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>, pavel@ucw.cz, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 10:16 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Oct 09, 2012 at 09:22:18AM -0700, Joe Perches wrote:
>> On Tue, 2012-10-09 at 21:40 +0530, Adil Mujeeb wrote:
>> > Repalces printk's with pr_debug
>> []
>> > diff --git a/linux-3.6-rc7/drivers/staging/winbond/wbusb.c b/linux-3.6-rc7/drivers/staging/winbond/wbusb.c
>> > index 0ca857a..48fe622 100644
>> > --- a/linux-3.6-rc7/drivers/staging/winbond/wbusb.c
>> > +++ b/linux-3.6-rc7/drivers/staging/winbond/wbusb.c
>> > @@ -79,18 +79,18 @@ static int wbsoft_add_interface(struct ieee80211_hw *dev,
>> >  static void wbsoft_remove_interface(struct ieee80211_hw *dev,
>> >                                 struct ieee80211_vif *vif)
>> >  {
>> > -   printk("wbsoft_remove interface called\n");
>> > +   pr_debug("wbsoft_remove interface called\n");
>>
>> It'd be more consistent to use
>>       pr_debug("%s called\n", __func__);
>> everywhere.
>>
>> It might be even nicer to remove almost all of these.
>>
>
> Yes, "tracing" type debug calls like this should all be removed, now
> that we have built-in function call tracing in the core kernel itself.

Thanks Joe and Greg for your quick comments. I will remove such
tracing calls and resubmit the patch.

Regards,
Adil

>
> greg k-h
