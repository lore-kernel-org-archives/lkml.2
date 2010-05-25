Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068Ab0EYUFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:05:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65335 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab0EYUFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:05:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uijcRsoLnUuTr6SySGL/6LjItQi52wTkbSgfZg4Y34mLhRe2UP42Kw6awn3M46Fbbt
         ajLhYciv27e799lrrMGT/jR6s0v0f6JYAkK0jVvaqKDqJUTOgRKkJp2kI/XVCUEyZh5W
         wHDUx2xlqtP95eVseL7d0i4NQT9Y8PXRhFJuw=
MIME-Version: 1.0
In-Reply-To: <1274165817.7859.16.camel@eee51>
References: <1274165817.7859.16.camel@eee51>
Date: Tue, 25 May 2010 12:59:52 -0700
X-Google-Sender-Auth: 19GotUqqu14No22IQggxRqdO-5M
Message-ID: <AANLkTilwpzIMVYi5GtI6FTQC_pNTSBMIB3_PUAQTE6AY@mail.gmail.com>
Subject: Re: (tsc) clock too slow on Core-i7/ASRock X58
From: john stultz <johnstul@us.ibm.com>
To: =?UTF-8?B?5a6+6KW/6JKZ?= <binximeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 11:56 PM, 宾西蒙 <binximeng@gmail.com> wrote:
> I have a problem with the system clock being off roughly 10 minutes a 2
> hours on a Xeon W3250 (like Core-i7 920) using the 2.6.34 Linux and tsc
> clocksource. Switching to hpet seems to improve the situation
> momentarily, however, are there any other thoughts on this matter?
>
> What I find odd is that the processor speed in dmesg (after TSC
> calibration message) is 2.8 GHz, whereas BIOS says @2.67GHz, might that
> be related?

So just to be clear, I assume the clock is ahead (fast) 10 minutes
every 2 hours, right?

Could you include or link to the full dmesg?

Did earlier kernels (prior to 2.6.34) work properly on this machine?

thanks
-john
