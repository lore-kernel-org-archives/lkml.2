Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab2LXIrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 03:47:17 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:47388 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2LXIrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 03:47:14 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Dec 2012 03:47:14 EST
MIME-Version: 1.0
In-Reply-To: <1356283278-5046-1-git-send-email-stigge@antcom.de>
References: <1356283278-5046-1-git-send-email-stigge@antcom.de>
Date: Mon, 24 Dec 2012 09:41:15 +0100
Message-ID: <CAHR064iQeQrQF0qrGXJoCmYny2H_H_JnV_h8OvRSmD=bGE5eYA@mail.gmail.com>
Subject: Re: [PATCH] samsung-laptop: Set keyboard backlight initially
From: Corentin Chary <corentin.chary@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, Matthew Garrett <mjg@redhat.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 6:21 PM, Roland Stigge <stigge@antcom.de> wrote:
> After boot, /sys/devices/platform/samsung/leds/samsung::kbd_backlight/brightness
> shows the maximum value (8) by readout, but the led is off. I need to manually
> set it to the respective value to have keyboard backlight.

If the led is set to 0, what's the value after reboot ? 0 or 8 ?
What's the behavior on windows ?

--
Corentin Chary
http://xf.iksaif.net
