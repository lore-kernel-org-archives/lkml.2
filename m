Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276Ab2IEULi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:11:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723Ab2IEULg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:11:36 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Yann Cantin <yann.cantin@laposte.net>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, jikos@suse.cz
Subject: Re: [eBeam PATCH 2/2] input: misc: New USB eBeam input driver.
Date: Wed, 05 Sep 2012 22:10:15 +0200
Message-ID: <2074509.XlRZ7oGjqX@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.6.0-rc2-12-desktop+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <5047AECE.80409@laposte.net>
References: <1346539923-9704-1-git-send-email-yann.cantin@laposte.net> <3991181.oZKWSZGdK8@linux-lqwf.site> <5047AECE.80409@laposte.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2012 21:58:06 Yann Cantin wrote:

> As ebeams are the only devices to my knowledge that work that way, i don't think
> a common API can be common, unless we mean an in-kernel generic purpose calibration
> API for input devices (stellar away for me), or a userland one (where should it be
> in the stack ?). Sincerely, this look overkill.
> 
> In the other hand, the actual ebeam module transformation feeding events subsys
> works very well and expose straight and usable data to userland (xorg evdev for now,
> and any program that can eat kernel's input data).

OK, I see the problem. You have no other choice.
 
> ##
> 
> I understand the sysfs interface is a problem. Eventually, in last resort, i can reduce
> it to 4 files : pass the 9 matrix parameters as one big string, removing min values. But
> i think this obfuscate the api for a marginal gain.

That would be wrong. The problem is a specific API. If it needs to be done
at all, it better be done as cleanly as possible.

	Regards
		Oliver

