Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab1EDPp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:45:58 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38882 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab1EDPp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:45:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=P3fBunhaxa6/H/5GTORrRV6Ox8aaVZi5izpnyF8+CXGaPPdwoReQPQbaeJFrcUqC3r
         oz2y9sYlYYEIMdm9nZ49CLw66mEbqCEowx4JQdDvl1YArVXQghmnHol4PLnEyb/YqAbH
         8ta27umOyRPrnA/dQqoJuOLjHCXQqXzwzRlAQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105041023070.5495@router.home>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
	<20110504083559.GB25724@elte.hu>
	<alpine.LFD.2.02.1105041124080.3005@ionos>
	<20110504101932.GA3392@elte.hu>
	<alpine.LFD.2.02.1105041233280.3005@ionos>
	<BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
	<20110504112746.GE8007@htj.dyndns.org>
	<alpine.LFD.2.02.1105041417330.3005@ionos>
	<20110504132022.GA17294@htj.dyndns.org>
	<alpine.LFD.2.02.1105041539050.3005@ionos>
	<20110504142532.GC17294@htj.dyndns.org>
	<alpine.LFD.2.02.1105041640020.3005@ionos>
	<alpine.DEB.2.00.1105040958570.5495@router.home>
	<BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com>
	<alpine.DEB.2.00.1105041023070.5495@router.home>
Date: Wed, 4 May 2011 18:37:23 +0300
X-Google-Sender-Auth: ABuW_a38sxqPkIfJF-5I0eD4T5g
Message-ID: <BANLkTik52Fi=vHY-TiK6SAYrWjaSN=PB+g@mail.gmail.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 6:28 PM, Christoph Lameter <cl@linux.com> wrote:
>> My gut reaction would be: let's do the minimal patch that just fixes
>> things to do irqsafe_cpu_cmpxchg_double() for 2.6.39, and then let's
>> remove the #ifdef'fery in -rc1. Or make _really_ sure that things are
>> ok for platforms that never even triggered the CMPXCHG_LOCAL case
>> before.
>>
>> Hmm?
>
> Ok. Pekka can put that patch in for the next round of merges?

Sure. Who's taking care of the minimal fix for .39?
