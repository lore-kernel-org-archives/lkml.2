Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab1AaHlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 02:41:01 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41192 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750912Ab1AaHlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 02:41:00 -0500
Date: Mon, 31 Jan 2011 08:40:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arthur Taylor <art@ified.ca>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org,
        alan@redhat.com
Subject: Re: [PATCH] vt: Add virtual console keyboard mode OFF
Message-ID: <20110131074048.GB4178@ucw.cz>
References: <AANLkTikZe1EuvNQHceNUdKFpmmeAbQG8H+34AG9fw43u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikZe1EuvNQHceNUdKFpmmeAbQG8H+34AG9fw43u@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2011-01-30 00:36:22, Arthur Taylor wrote:
> Add a new mode for the virtual console keyboard OFF to compliment RAW
> in which all key events are ignored. New mode prevents vt input
> buffers from overflowing when a program opens but doesn't read from a
> tty, like Xorg using only evdev for input.
> 
> The new mode is available by the ioctl KDSKBMODE with argument K_OFF
> from linux/kd.h. Does not effect sysrq behaviour.
> 
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alan Cox <alan@redhat.com>
> Signed-off-by: Arthur Taylor <art@ified.ca>


ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
