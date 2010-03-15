Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965866Ab0COXzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:55:16 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:39572 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965839Ab0COXzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:55:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KsidK8Fu3awS3H8Sn4augJtgFtD+3lPyguUJUEb/AtmiNWtlCkRAtFY5kz2a4+p20u
         ECZCr4cmC5VAkZjqwOPjcEL81RtTk0scZ7GwwRkANkTEYPs3ncJsakc0VS1jtCSXeQfm
         lN/Cy6JULY//wjmgX0BaEbWuX6XKnfO1iAC9k=
MIME-Version: 1.0
In-Reply-To: <201003160040.01774.rjw@sisk.pl>
References: <201002272143.22156.rjw@sisk.pl> <201003152227.11295.rjw@sisk.pl>
	 <3f9a31f41003151634k5f8521c0l99179bcf02d9e551@mail.gmail.com>
	 <201003160040.01774.rjw@sisk.pl>
Date: Tue, 16 Mar 2010 05:25:11 +0530
Message-ID: <3f9a31f41003151655l4b5d1a57nff18dcb0cf3060ab@mail.gmail.com>
Subject: Re: [PATCH] Driver core: Reduce the level of request_firmware() 
	messages
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

On Tue, Mar 16, 2010 at 5:10 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday 16 March 2010, Jaswinder Singh Rajput wrote:
>> Hello Rafael,
>>
>> On Tue, Mar 16, 2010 at 2:57 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >
>> > I still think it's a good idea.  The information about what firmware is being
>> > used doesn't seem to be very useful for anything but debugging, so I think
>> > KERN_DEBUG is actually the right level for these messages.
>> >
>>
>> Can we use printk_once()
>
> Yes, I guess so.
>
> OK, I'll rework the patch.
>

Good, so you need to prepare printk_once() with condition like in our
case so that it prints once for a particular name.

Thanks,
--
Jaswinder Singh.
