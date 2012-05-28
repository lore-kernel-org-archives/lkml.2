Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab2E1GiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 02:38:13 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:38670 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab2E1GiK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 02:38:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120424143624.GB3438@kroah.com>
References: <1335165396-23604-1-git-send-email-linus.walleij@stericsson.com>
	<20120423154342.GB23990@kroah.com>
	<CACRpkdabgGFCLGNFtje2efXoRHtk_uvb3yo6FTkH2pVGpHGB1A@mail.gmail.com>
	<20120424143624.GB3438@kroah.com>
Date: Mon, 28 May 2012 14:38:09 +0800
Message-ID: <CACRpkdZ0MnMLxvi4oFv-s8aut_zRfQh_OQN6HoXHkXmrtkSmzA@mail.gmail.com>
Subject: Re: [PATCH RESEND] driver core: always handle dpm_order
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 10:36 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Apr 24, 2012 at 02:11:09PM +0200, Linus Walleij wrote:
>> On Mon, Apr 23, 2012 at 5:43 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Mon, Apr 23, 2012 at 09:16:36AM +0200, Linus Walleij wrote:
>> >> From: Rabin Vincent <rabin.vincent@stericsson.com>
>> >>
>> >> If !dev->class, device_move() does not respect the dpm_order.
>> >> Fix it to do so.
>> >>
>> >> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>> >> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
>> >> Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
>> >> [Fixed a small dangling label compile warning]
>> >> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> >> ---
>> >>  drivers/base/core.c |   36 ++++++++++++++++++------------------
>> >>  1 file changed, 18 insertions(+), 18 deletions(-)
>> >
>> > Is this a problem in 3.4?  Older kernels?  Or can it wait for 3.5?
>>
>> Rabin said earlier that it could wait for 3.4 atleast.
>
> That didn't answer my question at all.  Oh well, 3.5 it is...

Is this going upstream in this merge window? I haven't seen it
in Torvalds' tree, but I guess it may be pending for a late
merge...?

Yours,
Linus Walleij
