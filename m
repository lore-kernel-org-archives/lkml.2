Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007Ab2KOWtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:49:51 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64152 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2KOWtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:49:49 -0500
Date: Thu, 15 Nov 2012 14:49:45 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 42/66] ALSA: Avoid endless sleep after disconnect
Message-ID: <20121115224945.GE16377@kroah.com>
References: <20121115040939.016421011@linuxfoundation.org>
 <20121115040942.165674081@linuxfoundation.org>
 <s5h8va3ba5k.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8va3ba5k.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 08:25:11AM +0100, Takashi Iwai wrote:
> At Wed, 14 Nov 2012 20:10:47 -0800,
> Greg Kroah-Hartman wrote:
> > 
> > 3.6-stable review patch.  If anyone has any objections, please let me know.
> 
> It turned out that this patch series for fixing USB-audio
> disconnection races need two more commits.  One is already in Linus
> tree,
> 
>     commit 8bb4d9ce08b0a92ca174e41d92c180328f86173f
>         ALSA: Fix card refcount unbalance
>     
> and another is included in the pull request I sent out to Linus right
> now,
> 
>     commit 10e44239f67d0b6fb74006e61a7e883b8075247a
>         ALSA: usb-audio: Fix mutex deadlock at disconnection
>     
> Please pick them up when possible, too.

Both now picked up, thanks.

> Sorry for inconvenience.

No problems at all, thanks for letting me know.

greg k-h
