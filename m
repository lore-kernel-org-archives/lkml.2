Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab3AJK7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:59:55 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:41315 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab3AJK7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:59:54 -0500
Message-ID: <50EE9F24.8010908@gmail.com>
Date: Thu, 10 Jan 2013 11:59:48 +0100
From: Adrian Byszuk <adrian.byszuk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: BUG: kernel panic on Dell Vostro 3560 when plugging in AC adapter
References: <50ED371A.3080903@gmail.com> <20130109120732.GA8016@liondog.tnic> <50ED98AA.1090304@gmail.com> <20130109170119.GA17840@liondog.tnic> <50EDB070.9020908@gmail.com> <20130109181520.GB17840@liondog.tnic>
In-Reply-To: <20130109181520.GB17840@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/13 19:15, Borislav Petkov wrote:
> On Wed, Jan 09, 2013 at 07:01:20PM +0100, Adrian Byszuk wrote:
>> I started bisecting and got situation where I don't see kernel panic,
>> but the whole system hangs - not sure in what direction go next, but
> 
> Hmm, git bisect skip should help here, look at the git-bisect manpage.
> 

I think I won't get the answer this way.
Bisecting between 3.7 and 3.8-rc2 (from linus tree) led me to commit
63e1ed2364050073770c085021377d7764969b85 titled "Update vt8500 PWM
driver support", which I think is rather nonsense.
Also, depending on bisected version, sometimes I got kernel panic, but
sometimes (more often) whole system would just freeze completely.

Any other way diagnose this bug?

Regards,
Adrian
