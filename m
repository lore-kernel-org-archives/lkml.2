Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab3AISB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 13:01:27 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:38636 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab3AISBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 13:01:24 -0500
Message-ID: <50EDB070.9020908@gmail.com>
Date: Wed, 09 Jan 2013 19:01:20 +0100
From: Adrian Byszuk <adrian.byszuk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: BUG: kernel panic on Dell Vostro 3560 when plugging in AC adapter
References: <50ED371A.3080903@gmail.com> <20130109120732.GA8016@liondog.tnic> <50ED98AA.1090304@gmail.com> <20130109170119.GA17840@liondog.tnic>
In-Reply-To: <20130109170119.GA17840@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/13 18:01, Borislav Petkov wrote:
> On Wed, Jan 09, 2013 at 05:19:54PM +0100, Adrian Byszuk wrote:
>> With 3.7.1 without staging modules I still get kernel panics, but
>> with 3.8.0-rc2 it looks like it's working correctly - I've tried the
>> unplug/plug sequence more than 5 times and it seems to work fine.
> 
> Hmm, you could bisect the set between 3.7.1..3.8.0-rc2 to find out which
> one to backport. If you can still reproduce it reliably and have time
> for bisecting, that is :).
> 
> Thanks.
> 

I started bisecting and got situation where I don't see kernel panic,
but the whole system hangs - not sure in what direction go next, but
I'll go forward to 3.8 until I get working version.

Thanks
