Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab0LHIie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:38:34 -0500
Received: from www.tglx.de ([62.245.132.106]:38934 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab0LHIid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:38:33 -0500
Date: Wed, 8 Dec 2010 09:38:21 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org
Subject: Re: [sodaville] [PATCH 01/11] x86/kernel: remove conditional early remap in parse_e820_ext
Message-ID: <20101208083821.GA22579@www.tglx.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de> <1290706801-7323-2-git-send-email-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1290706801-7323-2-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior | 2010-11-25 18:39:51 [+0100]:

>parse_setup_data() uses early_memremap() for a PAGE_SIZE mapping in
>order to figure out the type & size. If this mapping is not large enough
>then parse_e820_ext() will remap this area again via early_ioremap()
>since the first mapping is still in use.
>
>This patch attempts to simplify the handling and parse_e820_ext() does
>not need to worry about the mapping anymore.
>
>Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>CC: x86@kernel.org
>Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
>---

Nobody commented this and haven't seen it merged. Is it good to go?

Sebastian
