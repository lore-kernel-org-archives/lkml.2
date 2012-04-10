Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab2DJOgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:36:39 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:60532 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab2DJOgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:36:38 -0400
Date: Tue, 10 Apr 2012 07:36:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] driver core: always handle dpm_order
Message-ID: <20120410143633.GB14703@kroah.com>
References: <1331805498-12903-1-git-send-email-linus.walleij@stericsson.com>
 <20120315154323.GB23589@kroah.com>
 <CACRpkdaLhdjOU0CUfR3SWbDzB9qRLqBpBz+zUwPf_Q5Bu2otow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaLhdjOU0CUfR3SWbDzB9qRLqBpBz+zUwPf_Q5Bu2otow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 12:51:35PM +0200, Linus Walleij wrote:
> On Thu, Mar 15, 2012 at 4:43 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Mar 15, 2012 at 10:58:18AM +0100, Linus Walleij wrote:
> >> From: Rabin Vincent <rabin.vincent@stericsson.com>
> >>
> >> If !dev->class, device_move() does not respect the dpm_order.
> >> Fix it to do so.
> >
> > Is there code today in the kernel that needs this to go in now?  For
> > older releases?  Or is 3.4 acceptable?
> 
> To me it seems it has not been merged to 3.4 yet ... can we have it
> for the -rc:s?

Does it fix a bug somewhere?  If so, sure, but I didn't get the
impression that it did, and as it came after the merge window, I was
going to wait.

If this is incorrect, please let me know.

thanks,

greg k-h
