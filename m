Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab2IFGCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 02:02:25 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:35816 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2IFGCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 02:02:24 -0400
Date: Thu, 6 Sep 2012 08:02:20 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org
Subject: Re:
Message-ID: <20120906060220.GA252@x4>
References: <s5hmx1526mg.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hmx1526mg.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.09.04 at 16:40 +0200, Takashi Iwai wrote:
> ----------------------------------------------------------------
> Sound fixes for 3.6-rc5
> 
> There are nothing scaring, contains only small fixes for HD-audio and
> USB-audio:
> - EPSS regression fix and GPIO fix for HD-audio IDT codecs
> - A series of USB-audio regression fixes that are found since 3.5 kernel
> 
> ----------------------------------------------------------------
> Daniel Mack (4):
>       ALSA: snd-usb: Fix URB cancellation at stream start
>       ALSA: snd-usb: restore delay information
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
The commit fbcfbf5f above causes the following lines to be printed
whenever I start a new song:

delay: estimated 0, actual 352
delay: estimated 353, actual 705

(44.1 * 8 = 352.8)

This happens with an USB-DAC that identifies itself as "C-Media USB
Headphone Set".

-- 
Markus
