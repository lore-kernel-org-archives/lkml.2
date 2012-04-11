Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2DKHUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 03:20:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37016 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab2DKHUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 03:20:16 -0400
MIME-Version: 1.0
In-Reply-To: <201204110021.48140.rjw@sisk.pl>
References: <1331805498-12903-1-git-send-email-linus.walleij@stericsson.com>
	<20120315154323.GB23589@kroah.com>
	<CACRpkdaLhdjOU0CUfR3SWbDzB9qRLqBpBz+zUwPf_Q5Bu2otow@mail.gmail.com>
	<201204110021.48140.rjw@sisk.pl>
Date: Wed, 11 Apr 2012 09:20:15 +0200
Message-ID: <CACRpkdaUyEZQDC9QK4T6g7H0J8_RuJbbiLjn9h5zcHP-VkKE6g@mail.gmail.com>
Subject: Re: [PATCH] driver core: always handle dpm_order
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 12:21 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, April 10, 2012, Linus Walleij wrote:
>> On Thu, Mar 15, 2012 at 4:43 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Thu, Mar 15, 2012 at 10:58:18AM +0100, Linus Walleij wrote:
>> >> From: Rabin Vincent <rabin.vincent@stericsson.com>
>> >>
>> >> If !dev->class, device_move() does not respect the dpm_order.
>> >> Fix it to do so.
>> >
>> > Is there code today in the kernel that needs this to go in now?  For
>> > older releases?  Or is 3.4 acceptable?
>>
>> To me it seems it has not been merged to 3.4 yet ... can we have it
>> for the -rc:s?
>
> Could patch authors CC me on changes related to the code I'm supposed to
> maintain (e.g. device PM this particular case), please?

Ooops! Sorry.

> Also, please point me to the patch if that's not a problem.

Enjoy:
https://lkml.org/lkml/2012/3/15/70

Thanks for looking into this Rafael!
Yours,
Linus Walleij
