Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab1BTGOH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 01:14:07 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:36496 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1BTGOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 01:14:06 -0500
Message-ID: <bf012806f2016262399d27c911a8514d.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110220035143.15480.qmail@stuge.se>
References: <3f9bbd0924f54f6241cc16293fbcbbb4.squirrel@webmail.greenhost.nl>
    <20110219182511.GA3977@viiv.ffwll.ch>
    <20110220035143.15480.qmail@stuge.se>
Date: Sun, 20 Feb 2011 07:13:56 +0100 (CET)
Subject: Re: [BUG] drm/i915 Screen corruption introduced by 
     a00b10c360b35d6431a94cb
From: "Indan Zupancic" <indan@nul.nu>
To: "Peter Stuge" <peter@stuge.se>
Cc: "Indan Zupancic" <indan@nul.nu>, "Chris Wilson" <chris@chris-wilson.co.uk>,
        "LKML" <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: a350ae07b5350cdad28cef237d2e7179
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Sun, February 20, 2011 04:51, Peter Stuge wrote:
> Confirm I also have this issue on my X40, but there are other bugs
> that are much more significant so I haven't bothered mentioning this.

What issues? If it's backlight related, try my patch at:
http://lkml.org/lkml/2011/2/16/447

Or if the screen is black after suspend/screen blank then just try a
newer kernel, that got recently fixed. Actually, a lot of bugs were
recently introduced and fixed, with two months ago you're probably
in the new-bugs-only period, so I can recommend trying 2.6.38-rc5.

This screen corruption is the only problem for me, but I don't do anything
fancy with my laptop. The ipw2200 wireless driver is quite crappy, but it
has always been as far as I know. (Though not too long ago the USB got
burnt out, which probably took one RAM module with it, so now I'm running
with 512MB instead of 1GB, which is really noticeable when doing kernel
git stuff or compiles with this very very slow HD.)

Good luck,

Indan

P.S. Anyone any idea where that "Mail-Followup-To" header comes from?
Or is everyone subscribed to dri-devel automatically excluded from
Mail-Followup-To? If that's the case, pardon for the dubplicate mails.


