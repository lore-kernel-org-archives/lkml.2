Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220Ab1D2P6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:58:13 -0400
Received: from smtpout03.highway.telekom.at ([195.3.96.115]:51284 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751969Ab1D2P6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:58:11 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.39-rc5
Date: Fri, 29 Apr 2011 17:58:06 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.4; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com>
In-Reply-To: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104291758.06975@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds -- Wednesday 27 April 2011:
> Go forth and test,

Doesn't work on my notebook with i915/KMS. But then again, neither did
2.6.38 or any of its stable releases. The last working version was
2.6.38-rc8. The problem has been reported[1], but the bug got closed
in the wrong assumption that the bug is fixed. I reported that, too.
No reactions to that.

The bug was introduced with commit ba3820ade317ee36e496b9b40d2ec3987dd4aef0
by Takashi Iwai. The result is that when using KMS my notebook's[2] screen
remains dark, because the backlight isn't turned on.

Reverting commit ba3820ade317ee36e496b9b40d2ec3987dd4aef0 makes my
notebook work correctly again as it used to in 2.6.38-rc8 and before.

m.



[1] https://bugzilla.kernel.org/show_bug.cgi?id=31522
[2] Acer TravelMate 5735Z-452G32Mnss, using Intel GM45
