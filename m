Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab2DRUB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:01:56 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:60494 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab2DRUBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:01:55 -0400
Date: Wed, 18 Apr 2012 13:01:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] driver core: always handle dpm_order
Message-ID: <20120418200149.GA1584@kroah.com>
References: <1331805498-12903-1-git-send-email-linus.walleij@stericsson.com>
 <20120315154323.GB23589@kroah.com>
 <CACRpkdaLhdjOU0CUfR3SWbDzB9qRLqBpBz+zUwPf_Q5Bu2otow@mail.gmail.com>
 <201204110021.48140.rjw@sisk.pl>
 <CACRpkdaUyEZQDC9QK4T6g7H0J8_RuJbbiLjn9h5zcHP-VkKE6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaUyEZQDC9QK4T6g7H0J8_RuJbbiLjn9h5zcHP-VkKE6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 09:20:15AM +0200, Linus Walleij wrote:
> On Wed, Apr 11, 2012 at 12:21 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, April 10, 2012, Linus Walleij wrote:
> >> On Thu, Mar 15, 2012 at 4:43 PM, Greg Kroah-Hartman
> >> <gregkh@linuxfoundation.org> wrote:
> >> > On Thu, Mar 15, 2012 at 10:58:18AM +0100, Linus Walleij wrote:
> >> >> From: Rabin Vincent <rabin.vincent@stericsson.com>
> >> >>
> >> >> If !dev->class, device_move() does not respect the dpm_order.
> >> >> Fix it to do so.
> >> >
> >> > Is there code today in the kernel that needs this to go in now?  For
> >> > older releases?  Or is 3.4 acceptable?
> >>
> >> To me it seems it has not been merged to 3.4 yet ... can we have it
> >> for the -rc:s?
> >
> > Could patch authors CC me on changes related to the code I'm supposed to
> > maintain (e.g. device PM this particular case), please?
> 
> Ooops! Sorry.
> 
> > Also, please point me to the patch if that's not a problem.
> 
> Enjoy:
> https://lkml.org/lkml/2012/3/15/70
> 
> Thanks for looking into this Rafael!

Now dropped from my queue due to length of delay.  If you still
want/need this, please answer the questions I asked, and resend.

greg k-h
