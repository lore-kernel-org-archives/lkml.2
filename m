Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1D3IcN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 04:32:13 -0400
Received: from smtpout01.highway.telekom.at ([195.3.96.112]:63556 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751986Ab1D3IcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 04:32:08 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: i915/kms/backlight-combo mode problem (was: Re: Linux 2.6.39-rc5)
Date: Sat, 30 Apr 2011 10:32:04 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.4; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com> <201104292209.55154@rk-nord.at> <s5hpqo4b1kz.wl%tiwai@suse.de>
In-Reply-To: <s5hpqo4b1kz.wl%tiwai@suse.de>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104301032.05271@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Takashi Iwai -- Saturday 30 April 2011:
> I remember vaguely that the value zero could be interpreted as the max.

> Also, with the patch, does the backlight level can be adjusted
> correctly to different values?  I wonder whether LBPC adjustment
> really works or not on your machine.

> +			if (!lbpc)
> +				lbpc = 0xff; /* max value */

This change does *not* work on my machine. The screen stays black
again.

Yes, backlight adjustment generally works on this notebook, but only
with "acpi_osi=Linux" on the command line.

m.
