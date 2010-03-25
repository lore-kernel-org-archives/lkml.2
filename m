Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0CYMru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:47:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38997 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751221Ab0CYMrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:47:48 -0400
Date: Thu, 25 Mar 2010 12:50:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Giel van Schijndel <me@mortis.eu>
Cc: Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] hwmon: f71882fg: Add watchdog API for F71808E
 and F71889
Message-ID: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
In-Reply-To: <20100325104014.GC20126@salidar.me.mortis.eu>
References: <1269385936-3440-1-git-send-email-me@mortis.eu>
	<1269385936-3440-2-git-send-email-me@mortis.eu>
	<1269385936-3440-3-git-send-email-me@mortis.eu>
	<1269385936-3440-4-git-send-email-me@mortis.eu>
	<4BA9CF57.4030504@redhat.com>
	<20100324093651.GG6368@salidar.me.mortis.eu>
	<4BA9EA5C.9060506@redhat.com>
	<20100324153550.GK6368@salidar.me.mortis.eu>
	<20100324155151.2482952f@lxorguk.ukuu.org.uk>
	<20100325085450.GA20126@salidar.me.mortis.eu>
	<20100325104014.GC20126@salidar.me.mortis.eu>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> Using Alan's patch and the one following the dashed line I can implement
> (and have already done so) a separate watchdog driver for the Fintek
> F71808E.
> 
> Should I just ask for this patch to be applied together with Alan's?
> Then submit the new driver? (I'm a bit new to the non-technical aspects
> of Linux kernel development).

I'd expect to see a submission of three patches I think

1. Patch adding the muxed resource support
2. Patch making the hwmon driver use it
3. Patch adding the new driver which needs it

and then we have a few other bits of code that probably should adopt it,
but that is a separate matter and other maintainers can do that bit.

Alan
