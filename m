Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab1FNTT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 15:19:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54234 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1FNTT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 15:19:28 -0400
MIME-Version: 1.0
In-Reply-To: <201106142017.41558.arnd@arndb.de>
References: <1307079502-6326-1-git-send-email-jim.cromie@gmail.com>
 <201106141607.02171.arnd@arndb.de> <BANLkTinrbrsEORxMd96K2obvfGjswegP+g@mail.gmail.com>
 <201106142017.41558.arnd@arndb.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 14 Jun 2011 13:19:08 -0600
X-Google-Sender-Auth: txPQKcjFkxMnwARhL_oYJWuIz7w
Message-ID: <BANLkTikDufSSNwcHe26YPdc8WLDcM1QG_g@mail.gmail.com>
Subject: Re: [PATCH] fix bogus use of rc = alloc_chrdev_region()
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>, Jim Cromie <jim.cromie@gmail.com>,
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
> nonstandard API or do you prefer them to live amongst the regular ones?'

I only see one files per non-standard driver.  I wouldn't bother with
subdirectories.  Just put them in with the general population.

g.
