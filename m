Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab1H2LQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:16:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:35347 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1H2LQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:16:11 -0400
Date: Mon, 29 Aug 2011 13:16:07 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] sound: usb: mixer: increase control transfer timeout
Message-ID: <20110829111607.GB21556@linutronix.de>
References: <1314616226-15942-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1314616226-15942-1-git-send-email-balbi@ti.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi | 2011-08-29 14:10:26 [+0300]:

>Not sure this information is valid on a commit log, but I
>have a FPGA-platform which I use to test my USB controller
>and when that's running on FS, this message fails because
>control message times out before controller has the opportunity
>to complete all three phases of the SETUP transaction.

Does it still happen if you remove all the debug output from your udc
driver?

Sebastian
