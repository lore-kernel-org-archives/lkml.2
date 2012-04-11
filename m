Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2DKHYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 03:24:36 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58986 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab2DKHYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 03:24:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120410143633.GB14703@kroah.com>
References: <1331805498-12903-1-git-send-email-linus.walleij@stericsson.com>
	<20120315154323.GB23589@kroah.com>
	<CACRpkdaLhdjOU0CUfR3SWbDzB9qRLqBpBz+zUwPf_Q5Bu2otow@mail.gmail.com>
	<20120410143633.GB14703@kroah.com>
Date: Wed, 11 Apr 2012 09:24:35 +0200
Message-ID: <CACRpkdZ73Gv4dac=cqFUKRL_x3uVwrcwjmtJJwnVRT6BmUA_Jw@mail.gmail.com>
Subject: Re: [PATCH] driver core: always handle dpm_order
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 4:36 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Apr 10, 2012 at 12:51:35PM +0200, Linus Walleij wrote:
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
> Does it fix a bug somewhere?  If so, sure, but I didn't get the
> impression that it did, and as it came after the merge window, I was
> going to wait.

Que? It arrived the 15th of march, two weeks ahead of the merge
window... But no big deal, Rafael need to review it so no hurries.

Thanks,
Linus Walleij
