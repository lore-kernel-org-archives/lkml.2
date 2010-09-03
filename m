Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab0ICMoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:44:46 -0400
Received: from mv-drv-hcb004.ocn.ad.jp ([118.23.109.134]:60843 "EHLO
	mv-drv-hcb004.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0ICMop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:44:45 -0400
Date: Fri, 03 Sep 2010 21:44:38 +0900 (JST)
Message-Id: <20100903.214438.232976322.anemo@mba.ocn.ne.jp>
To: mcuos.com@gmail.com
Cc: geert@linux-m68k.org, akpm@linux-foundation.org, a.zummo@towertech.it,
        linux-kernel@vger.kernel.org
Subject: Re: rtc/m41t80: use rtc_valid_tm() to check returned tm
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20100817.230531.95061739.anemo@mba.ocn.ne.jp>
References: <AANLkTin7+UPYJ5tsyrbUhxcEfbHLMVJQOSrV1_3zQ0V3@mail.gmail.com>
	<AANLkTimbtkvrE0Lhk4vcq-4N3Sr8T84zD7-pkSotO66L@mail.gmail.com>
	<20100817.230531.95061739.anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 23:05:31 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> No, t->time does not contain complete date/time.  It just holds some
> alarm settings and -1 for some fields.
> 
> So rtc_valid_tm(&t->time) will always returns -EINVAL.
> The correct fix would be just reverting rtc_valid_tm here.
> 
> ------------------------------------------------------
> From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> Subject: [PATCH] rtc: m41t80: do not use rtc_valid_tm in m41t80_rtc_read_alarm

Sorry, the patch contains non UTF-8 commit log.
I will resend the patch with corrected commit log.

---
Atsushi Nemoto
