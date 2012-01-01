Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab2AAUuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 15:50:24 -0500
Received: from bues.ch ([80.190.117.144]:38272 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab2AAUuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 15:50:22 -0500
Date: Sun, 1 Jan 2012 21:50:00 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Marek Vasut <marek.vasut@gmail.com>, Oliver Neukum <oliver@neukum.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Matthew Garrett <mjg@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120101215000.04b13f43@milhouse>
In-Reply-To: <20120101203945.0ebc2f55@pyramind.ukuu.org.uk>
References: <20111230235421.GA6054@redhat.com>
	<201201011054.47233.marek.vasut@gmail.com>
	<201201011328.41311.oliver@neukum.org>
	<201201011732.23069.marek.vasut@gmail.com>
	<20120101203945.0ebc2f55@pyramind.ukuu.org.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jan 2012 20:39:45 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> When you suspend the power gets killed so the device loses its firmware
> and goes back to being a firmware requesting thing on resume.
> 
> Worse still - you don't easily know if the device is in fact new and was
> added while suspended, or was always there.
> 
> So for those devices you do need to load the firmware into them
> automatically after the resume to work out what they are and get the MAC
> to see if its the same wireless card or not.

Well, that does not prevent you from caching the firmware once you
got it from userspace and keep it until module unload (or probably device
close), so that it is already available on resume.

-- 
Greetings, Michael.
