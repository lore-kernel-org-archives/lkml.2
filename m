Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab2AAQc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 11:32:28 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58475 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2AAQc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 11:32:27 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Sun, 1 Jan 2012 17:32:22 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Matthew Garrett <mjg@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
References: <20111230235421.GA6054@redhat.com> <201201011054.47233.marek.vasut@gmail.com> <201201011328.41311.oliver@neukum.org>
In-Reply-To: <201201011328.41311.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201011732.23069.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Am Sonntag, 1. Januar 2012, 10:54:47 schrieb Marek Vasut:
> > > Am Samstag, 31. Dezember 2011, 19:39:18 schrieb Marek Vasut:
> > > > maybe we should implement such thing into the firmware loader itself?
> > > > Allow it -- for example via some node in /dev -- to force loading
> > > > firmware into some buffer in kernel just before suspend so it'll
> > > > certainly be readily available at resume time?
> > > 
> > > This is difficult. We don't know at suspend time which firmware we will
> > > need at resume time.
> > 
> > That's not actually true ... you can ask the drivers if they need to load
> > firmware after resume ... that can be implemented and udev can handle it.
> > The driver should know if the hardware it's controlling is stupid or
> > not.
> 
> Device IDs can morph due to a power loss. After resumption another driver
> would bind.

What do you mean? I don't think I quite follow.

M

> 
> 	Regards
> 		Oliver
