Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab1FNQYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 12:24:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45384 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1FNQYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 12:24:10 -0400
MIME-Version: 1.0
In-Reply-To: <201106141607.02171.arnd@arndb.de>
References: <1307079502-6326-1-git-send-email-jim.cromie@gmail.com>
 <BANLkTi=8bv54-Z=xCyqUhFAnxM5G40k2WQ@mail.gmail.com> <20110610204403.GA13450@kroah.com>
 <201106141607.02171.arnd@arndb.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 14 Jun 2011 10:23:50 -0600
X-Google-Sender-Auth: PrFbXSnyB9rY5tOU5kB_wIw11UA
Message-ID: <BANLkTinrbrsEORxMd96K2obvfGjswegP+g@mail.gmail.com>
Subject: Re: [PATCH] fix bogus use of rc = alloc_chrdev_region()
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>, Jim Cromie <jim.cromie@gmail.com>,
        linux-kernel@vger.kernel.org, rpjday@crashcourse.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 8:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 10 June 2011, Greg KH wrote:
>> On Fri, Jun 10, 2011 at 02:29:42PM -0600, Jim Cromie wrote:
>> > can someone pick this up,
>> > for this release or next ?
>>
>> It was rumored that Arnd wanted to take over drivers/char/.
>
> That's true. It probably means I should set up a tree now, before we get
> too close to the next merge window.
>
> On the topic of drivers/char/{nsc_gpio,pc8736x_gpio,scx200_gpio}, I wonder
> if we should move them to drivers/gpio/nsc_gpio despite the fact that they
> use a different (older) interface than all the other gpio drivers.

I have no problem with moving them into drivers/gpio.  When you do,
please rename then drivers/gpio/gpio-*.c

g.
