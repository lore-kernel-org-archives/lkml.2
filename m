Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0DMClB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 22:41:01 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:42748 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab0DMClA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 22:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Z40DIRdZRC6o8cZCMgkgMK079NdbApYrOtnBMCmTUTKZftb2ikbLMMVNGlKPuBNrKA
         /DPMpHfdRgNnrbcae3ZHB/Vzewuxn/0wP4pMiSr0Cps2yBATOBFnUzrYZlc6WxRPn/PZ
         gTVVg5G4JVFgvPnEBEZ6YZsDjvbiiHvCVo0wQ=
Message-ID: <4BC3DA02.2020208@gmail.com>
Date: Mon, 12 Apr 2010 19:42:10 -0700
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34-rc4
References: <alpine.LFD.2.00.1004121859480.3647@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004121859480.3647@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 07:16 PM, Linus Torvalds wrote:
>
> It's been two weeks rather than the usual one, because we've been hunting
> a really annoying VM regression that not a lot of people seem to have
> seen, but I didn't want to release an -rc4 with it. So we had the choice
> of either reverting all the anon-vma scalability improvements, or finding
> out exactly what caused the regression and fixing it.
>
> And we got pretty close to the point where I was going to just revert it
> all.
>
> Absolutely _huge_ kudos to Borislav Petkov who reported the problem and
> was able to not just reliably reproduce it, but also test new patches to
> try to narrow things down at a moments notice. The thing took ten days of
> emails flying back and forth, and Borislav was there all the time, day and
> night, through several patches that tried to fix it (several real bugs,
> but not the one he hit) and lots of patches to just add instrumentation to
> get us nearer to the cause of the problem.
>
> And finally, today, confirmation that we actually nailed the problem. So
> if anybody has been seeing a oops (or sometimes a GP fault) in
> page_referenced(), that should be gone now.
>
> Anyway, there's certainly been other things going on too, but the VM
> regression was the one that kept me personally busy, and held up the
> release.
>
> The bulk of the changes come from drivers - a new network driver (cxgb4),
> but also updates to the radeon and nouveau drivers.
>
> And then there is the random updates everywhere. The appended shortlog is
> about as good an overview as anything.
>
> 		Linus
>
> ---


I noticed the vm discussion, but had no idea what was going on.
In any case that's pretty cool to see(read). Love to see the hard
work and collaboration to fix a problem.

cheers,

Justin P. Mattock
