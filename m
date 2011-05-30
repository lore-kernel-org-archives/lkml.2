Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1E3MlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:41:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59893 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1E3MlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:41:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XeXf1H3/5mLxu7KyNJvBW4I7hf+xbRtWzVcqyg1eHop89blWQJ+Ull0kPKvX+EU95w
         2jSdcW3z+2uNpMWXezvNFR3nX2T1qQGNgJqDyYF/aOF4by442+YRQbja7F/8RvEZ+Toa
         /pbpkO4vyRQ5Lv6lx/QljWL3lw1nZQAlpY4RI=
MIME-Version: 1.0
In-Reply-To: <1305851091-10096-1-git-send-email-ccross@android.com>
References: <1305851091-10096-1-git-send-email-ccross@android.com>
Date: Mon, 30 May 2011 14:41:08 +0200
X-Google-Sender-Auth: f8wtiJvoVDO1ky3hTHOk1z8qwP8
Message-ID: <BANLkTinLXGupiadbE_mX=EeS_g+7oKvzkA@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: smp_twd: Reconfigure clockevents after cpufreq change
From: Linus Walleij <linus.walleij@linaro.org>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/20 Colin Cross <ccross@android.com>:

> The localtimer's clock changes with the cpu clock.  After a
> cpufreq transition, update the clockevent's frequency and
> reprogram the next clock event.

Colin can you put this into Russells patch tracker with all the ACKs?

Actually I think this is -rc material since it fixes a real bug for us
atleast, maybe that's just me.

Yours,
Linus Walleij
