Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1FNSX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:23:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32963 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab1FNSXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:23:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sUm6mWtAI0lmr+06eA+Ip5KDAW8elKjRWD51FlFCWFh61aeLzfZosEFO1z14f3Lv1V
         PZj9KWqNYgfX88lSR4wBPQ6ipofcHt1lduWLUstkv+b7MnkZjTzVlJF4GCp2Djl+/+o4
         Zd2lzDaOAqsXdttucUAYMqebNzkxmB5v8VGpg=
MIME-Version: 1.0
In-Reply-To: <201106142017.41558.arnd@arndb.de>
References: <1307079502-6326-1-git-send-email-jim.cromie@gmail.com>
 <201106141607.02171.arnd@arndb.de> <BANLkTinrbrsEORxMd96K2obvfGjswegP+g@mail.gmail.com>
 <201106142017.41558.arnd@arndb.de>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 14 Jun 2011 12:23:21 -0600
Message-ID: <BANLkTinY_OA_sg+texQb-L-T9dowZ=2PrA@mail.gmail.com>
Subject: Re: [PATCH] fix bogus use of rc = alloc_chrdev_region()
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, rpjday@crashcourse.ca
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 12:17 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 14 June 2011 18:23:50 Grant Likely wrote:
>> On Tue, Jun 14, 2011 at 8:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> > On the topic of drivers/char/{nsc_gpio,pc8736x_gpio,scx200_gpio}, I wonder
>> > if we should move them to drivers/gpio/nsc_gpio despite the fact that they
>> > use a different (older) interface than all the other gpio drivers.
>>
>> I have no problem with moving them into drivers/gpio.  When you do,
>> please rename then drivers/gpio/gpio-*.c
>
> Ok. Should they be in a subdirectory drivers/gpio/nsc_gpio/gpio_* for the
> nonstandard API or do you prefer them to live amongst the regular ones?
>

converting these to gpiolib has been on my list for a while, but
pretty far down.
Moving them is an easy 1st step.
Once theyre converted, I guess they belong with the others,
but its easy to move them again when the convert is done.
preference ?

>        Arnd
>
