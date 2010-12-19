Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab0LSQsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 11:48:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47133 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664Ab0LSQsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 11:48:17 -0500
Date: Sun, 19 Dec 2010 17:48:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.37-rc6] led_trigger_unregister protection fault...
Message-ID: <20101219164812.GA24894@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel.blueman@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <AANLkTinz5aj9MDXCxogYgLypF7x4BwscR6Ndu5R6ybcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTinz5aj9MDXCxogYgLypF7x4BwscR6Ndu5R6ybcA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 12:55:43PM +0000, Daniel J Blueman wrote:
> With 2.6.37-rc6, when hot-removing the battery on my Studio 1557 i7
> laptop with AC power, kworker/0:2 hit a protection fault in
> led_trigger_unregister_oops [1].

Got the same oops and started analyzing it but the oops in
led_trigger_unregister() is actually the third one in a row when
unplugging the battery.

See http://marc.info/?l=linux-kernel&m=129276362410145 for a complete
oops. You might want to try the patch there to see if it fixes the issue
for you too.

Thanks.

-- 
Regards/Gruss,
    Boris.
