Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2FPPns (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 11:43:48 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:51603 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab2FPPnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 11:43:45 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: =?utf-8?Q?Bj=C3=B8rn?= Mork <bjorn@mork.no>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [-next] FATAL: drivers/gpu/drm/udl/udl: sizeof(struct usb_device_id)=24 is not a modulo of the size of section __mod_usb_device_table=44.
References: <CAMuHMdXk6pByz14JcDgY+UE6QM0sHD8cbXye9CgOVSRRtr7J+Q@mail.gmail.com>
	<20120615201021.GB14544@kroah.com>
	<CAMuHMdUj6tAcWhkSkV43Kw3-2-3+JzgP6W=2w3fjL2KBfRh9ZQ@mail.gmail.com>
	<20120615231220.GC8205@kroah.com> <87lijns84s.fsf@nemi.mork.no>
X-Yow: ..  I don't know why but, suddenly, I want to discuss declining I.Q.
 LEVELS with a blue ribbon SENATE SUB-COMMITTEE!
Date: Sat, 16 Jun 2012 17:43:40 +0200
In-Reply-To: <87lijns84s.fsf@nemi.mork.no> (=?utf-8?Q?=22Bj=C3=B8rn?=
 Mork"'s message of "Sat, 16
	Jun 2012 15:23:31 +0200")
Message-ID: <m2bokjb6tv.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjørn Mork <bjorn@mork.no> writes:

> AFAIK (which admittedly is not much wrt cross building) there is no way
> we can make the host built file2alias know the proper aligment for the
> structure in the target built modules.  That's the background for this
> fix: 
>
> commit 4ce6efed48d736e3384c39ff87bda723e1f8e041
> Author: Sam Ravnborg <sam@uranus.ravnborg.org>
> Date:   Sun Mar 23 21:38:54 2008 +0100
>
>     kbuild: soften modpost checks when doing cross builds

This is not a fix in any sense of the word.  modpost can only work
properly if its view of the device_id structures matches *exactly* that
of the target.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
