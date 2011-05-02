Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab1EBNMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 09:12:46 -0400
Received: from smtpout04.highway.telekom.at ([195.3.96.117]:27930 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758426Ab1EBNMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 09:12:45 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: i915/kms/backlight-combo mode problem (was: Re: Linux 2.6.39-rc5)
Date: Mon, 2 May 2011 15:12:40 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.4; KDE/4.6.2; x86_64; ; )
Cc: Takashi Iwai <tiwai@suse.de>, Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org,
        Carlos Corbacho <carlos@strangeworlds.co.uk>
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com> <201104301334.53928@rk-nord.at> <s5hiptttick.wl%tiwai@suse.de>
In-Reply-To: <s5hiptttick.wl%tiwai@suse.de>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105021512.41137@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Takashi Iwai -- Monday 02 May 2011:
* > At Sat, 30 Apr 2011 13:34:51 +0200, Melchior FRANZ wrote:
> > * Takashi Iwai -- Saturday 30 April 2011:
> > > acpi_osi quirk should be better added statically, then.
> > 
> > No, I guess the problem here is that acer_wmi doesn't support this
> > machine yet.

> Hm, but the backlight control is done via the standard ACPI, no?

I have no idea. If I were an expert, I would just have sent a
patch, not a bug report. And I prefer fixes to "quirks".  :-P



> BTW, did you try my previous patch?

Works. I hadn't tested it before, because you seemed to wait
for the opinion of some Intel people, and so did I. But thanks
for that code!

m.
