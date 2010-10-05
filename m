Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab0JEGRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 02:17:38 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:34263 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab0JEGRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 02:17:36 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RESEND] [PATCH] Input: add appleir USB driver
Date: Tue, 5 Oct 2010 08:18:35 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Bastien Nocera <hadess@hadess.net>,
        "linux-input" <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1285844276.26405.26.camel@cookie.hadess.net> <201010050802.14271.oliver@neukum.org> <20101005060822.GD15355@core.coreip.homeip.net>
In-Reply-To: <20101005060822.GD15355@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010050818.35118.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 5. Oktober 2010, 08:08:22 schrieb Dmitry Torokhov:
> > But what about the next opener? He'll get a completely spurious
> > key release event, as the next key is pressed.
> 
> How does the opening of a device handle relate to a device state?

It doesn't.

> Userspace should expect to see releases without presses (in case they
> weren't the first client that opened the device).

Yes, but based on sane timing. From the time stamps user space
would conclude that the key had been pressed at an unknown time
before open and released at the time the event indicates. Possibly
it would compute that the key had been held for at least hours.

	Regards
		Oliver
