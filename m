Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab2DOXiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 19:38:17 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:45425 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab2DOXiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 19:38:16 -0400
Date: Mon, 16 Apr 2012 08:38:13 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Subject: Realtek codec eating up battery?
Message-ID: <20120415233813.GA10731@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

(please Cc)

running a recent git kernel from today, I see the following in powertop:
  1.02 W    100.0%    Device         Audio codec hwC0D0: Realtek

I am quite sure that was not the case in former times, so I wanted to ask
if you think this is a kernel change or a user space change that is
responsible for that?

AFAIR before I was running on top of git 7c427f45, now
on git 6c23b8e9 and there have been quite some changes regarding realtek
in the meantime:
    * tag 'sound-3.4' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound:
      ALSA: hda/realtek - Fix mem leak (and rid us of trailing whitespace).
      ALSA: hda/realtek - Add quirk for Mac Pro 5,1 machines
      ALSA: hda/realtek - Add a fixup entry for Acer Aspire 8940G
      ALSA: hda/realtek - Fix GPIO1 setup for Acer Aspire 4930 & co
      ALSA: hda/realtek - Add a few ALC882 model strings back

output of dmesg wrt realtek/hda:
[   20.952213] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   21.004975] hda_codec: ALC262: SKU not ready 0x411111f0
[   21.008167] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input10
[   21.011878] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   21.013351] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12


Thanks a lot and all the best

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
`You know they've reintroduced the death penalty for
insurance company directors?'
No I didn't. For what offence?'
Trillian frowned.
`What do you mean, offence?'
`I see.'
                 --- Evidence that there will be some justice in the Universe
                 --- eventually.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
