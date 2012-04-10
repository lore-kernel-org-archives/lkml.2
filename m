Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab2DJWRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 18:17:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34933 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728Ab2DJWRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 18:17:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] driver core: always handle dpm_order
Date: Wed, 11 Apr 2012 00:21:47 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>
References: <1331805498-12903-1-git-send-email-linus.walleij@stericsson.com> <20120315154323.GB23589@kroah.com> <CACRpkdaLhdjOU0CUfR3SWbDzB9qRLqBpBz+zUwPf_Q5Bu2otow@mail.gmail.com>
In-Reply-To: <CACRpkdaLhdjOU0CUfR3SWbDzB9qRLqBpBz+zUwPf_Q5Bu2otow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204110021.48140.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 10, 2012, Linus Walleij wrote:
> On Thu, Mar 15, 2012 at 4:43 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Mar 15, 2012 at 10:58:18AM +0100, Linus Walleij wrote:
> >> From: Rabin Vincent <rabin.vincent@stericsson.com>
> >>
> >> If !dev->class, device_move() does not respect the dpm_order.
> >> Fix it to do so.
> >
> > Is there code today in the kernel that needs this to go in now?  For
> > older releases?  Or is 3.4 acceptable?
> 
> To me it seems it has not been merged to 3.4 yet ... can we have it
> for the -rc:s?

Could patch authors CC me on changes related to the code I'm supposed to
maintain (e.g. device PM this particular case), please?

Also, please point me to the patch if that's not a problem.

Thanks,
Rafael
