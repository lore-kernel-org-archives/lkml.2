Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab0FWRz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:55:28 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57604 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab0FWRz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:55:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WvdQmyzdYEiYb2CgmR1x7GH8uJ4pKbgTvqSjJdP3yMEsozlF+vSLrqkqUfZQR6QBic
         M9i/3KkVaOqIEZDIXUnEoVe90I1Y4GubVOLpG/kDydK9yEfONKaGmKFd2p2vo4bzL1AA
         z5/xD315qEtdoqBbyMU0WQ+wZHq8vPN43Wga4=
MIME-Version: 1.0
In-Reply-To: <87bpb1fxwg.fsf@old-tantale.fifi.org>
References: <AANLkTim362_xv5FAyFSpdnAFUlILliEoGBW8_oZ4QVj1@mail.gmail.com>
	<87bpb1fxwg.fsf@old-tantale.fifi.org>
Date: Wed, 23 Jun 2010 13:55:25 -0400
X-Google-Sender-Auth: Ms7AFudhyEnBeg5PauEhBloi5dU
Message-ID: <AANLkTinm1ZXybaAgCUGGPkK_YKaGmO9k2mduoy9ThnQ3@mail.gmail.com>
Subject: Re: i915: Dell E6410 Ironlake LVDS detection
From: Ben Guthro <ben@guthro.net>
To: Philippe Troin <phil@fifi.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 1:42 PM, Philippe Troin <phil@fifi.org> wrote:
> I am seeing similar problems with an HP Elitebook 2540p.
>
> 2.6.32 works for me.
> 2.6.33.5 does not.

I have tried ubuntu mainline builds of:

2.6.32.21
2.6.32.22
2.6.34-rc3
2.6.35-rc1
2.6.34-drm-intel-next

None have worked yet...

> I'm not sure if this hardware has a LVDS connector.

Apologies...mistyped. I meant the LVDS internal display, not connector.

> I was able to boot it with i915 loaded (-> black screen), ssh in and
> run xrandr.  Xrandr reported 6 connectors, none of them named LVDS.
> It think they were named FP[123].
>
> I was able to turn on an external display connected via VGA with
> xrandr and it seemed to be working fine?

When I boot without the external display, I am never able to ssh in -
and I do not get the sound that typically plays when X is booted.

I've put this onto a serial line, and it seems to hang sometime in
init...with some indicators that it is when it switches over to the
higher resolution console...but the screen is black, so this is really
just a gut feel.
