Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab2L1D0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 22:26:47 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60846 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab2L1D0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 22:26:45 -0500
Date: Thu, 27 Dec 2012 19:30:11 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        khoroshilov@ispras.ru
Subject: Re: Linux 3.8-rc1 (mei driver BROKEN)
Message-ID: <20121228033011.GA26616@kroah.com>
References: <CA+icZUVRrAcNy2_JsYAS5Ff=c6tthHHB=rj3eHPFcwUh5APiug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVRrAcNy2_JsYAS5Ff=c6tthHHB=rj3eHPFcwUh5APiug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 02:04:23AM +0100, Sedat Dilek wrote:
> Hi Linus,
> 
> I am not sure if Greg is on holidays as his char-misc GIT tree didn't
> get updated the last days.

Yes, I'm supposed to be on vacation until the 7th.

> The MEI driver causes here a serious regression requiring a hard cold
> start of the machine I am working on.
> A fix "mei: fix mismatch in mutex unlock-lock in mei_amthif_read()"
> was already sent to LKML [1] and fixes the issue for me.
> 
> Can you push that a bit?

These patches are in my "to-apply" queue, which I will get to Linus in
time for 3.8-final, so there's no rush on your end needed.

thanks,

greg k-h
