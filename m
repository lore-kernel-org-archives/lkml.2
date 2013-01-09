Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab3AIRBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 12:01:22 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45599 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298Ab3AIRBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 12:01:21 -0500
Date: Wed, 9 Jan 2013 18:01:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: Adrian Byszuk <adrian.byszuk@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: BUG: kernel panic on Dell Vostro 3560 when plugging in AC adapter
Message-ID: <20130109170119.GA17840@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Adrian Byszuk <adrian.byszuk@gmail.com>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <john.stultz@linaro.org>
References: <50ED371A.3080903@gmail.com>
 <20130109120732.GA8016@liondog.tnic>
 <50ED98AA.1090304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50ED98AA.1090304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 05:19:54PM +0100, Adrian Byszuk wrote:
> With 3.7.1 without staging modules I still get kernel panics, but
> with 3.8.0-rc2 it looks like it's working correctly - I've tried the
> unplug/plug sequence more than 5 times and it seems to work fine.

Hmm, you could bisect the set between 3.7.1..3.8.0-rc2 to find out which
one to backport. If you can still reproduce it reliably and have time
for bisecting, that is :).

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
