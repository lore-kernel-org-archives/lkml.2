Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3ACTlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 14:41:13 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52056 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab3ACTlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 14:41:09 -0500
MIME-Version: 1.0
In-Reply-To: <20130103131156.214bd7a5@pyramind.ukuu.org.uk>
References: <CAMVG2ssA-B6s+F-g4mL0dbBSVsNupzT1nm1Kc70dXHGsNQuNYA@mail.gmail.com>
 <20130103131156.214bd7a5@pyramind.ukuu.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Jan 2013 11:40:47 -0800
X-Google-Sender-Auth: uaslviE2hpjTzIBrvb5wj8dw478
Message-ID: <CA+55aFyseLhQj-u7XOdCayMN2dJ+LaKKxSN2NrfqFA98o1WW+A@mail.gmail.com>
Subject: Re: 3.8-rc2: EFI framebuffer lock inversion...
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Daniel J Blueman <daniel@quora.org>, Peter Jones <pjones@redhat.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        nouveau@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 5:11 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> The fb layer locking was broken. I posted patches early December which
> should have fixed the ones we know about. ('fb: Rework locking to fix
> lock ordering on takeover').

That patch causes compile errors with "allmodconfig":

  ERROR: "do_take_over_console" [drivers/video/console/fbcon.ko] undefined!
  make[1]: *** [__modpost] Error 1
  make: *** [modules] Error 2
  make: *** Waiting for unfinished jobs....

Hmm?

               Linus
