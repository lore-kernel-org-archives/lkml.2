Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab1EFIwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 04:52:11 -0400
Received: from smtpout04.highway.telekom.at ([195.3.96.117]:32523 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754537Ab1EFIwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 04:52:09 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: i915/kms/backlight-combo mode problem
Date: Fri, 6 May 2011 10:52:06 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.5; KDE/4.6.2; x86_64; ; )
Cc: Takashi Iwai <tiwai@suse.de>, Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Joey Lee <jlee@novell.com>
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com> <s5htyd9kumz.wl%tiwai@suse.de> <201105052242.22217@rk-nord.at>
In-Reply-To: <201105052242.22217@rk-nord.at>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105061052.06638@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Melchior FRANZ -- Thursday 05 May 2011:
> This revised patch works correctly for me.

... and changing backlight brightness worked with acpi_osi=Linux, too.
Unfortunately, that does no longer work now, although I haven't changed
anything. Pressing the brightness buttons causes some ACPI debug output,
but it doesn't adjust anything.

m. 
