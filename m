Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab2JAHYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 03:24:05 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55489 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab2JAHYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 03:24:01 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20120930143201.GA22107@kroah.com>
References: <2372445.fuIXicT4H0@tux200s>
	<CAKMK7uFm7YVMeUKUj4wmCeV4myYYODrp2XFDn5O8PHmjg3_U4g@mail.gmail.com>
	<20120928160656.GE2625@kroah.com>
	<12610424.iJ3m5UY2ZS@tux200s>
	<20120930143201.GA22107@kroah.com>
Date: Mon, 1 Oct 2012 09:24:00 +0200
X-Google-Sender-Auth: t9j3IPm4Hdotd50f987H_2iInGs
Message-ID: <CAKMK7uE-L-+bFxJad3-pa-8i2MwvYw4_vYoWM8S-bxRmKruzoQ@mail.gmail.com>
Subject: Re: Re: 3.4.10 i915 [GM45] regression
From: Daniel Vetter <daniel@ffwll.ch>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 4:32 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sun, Sep 30, 2012 at 01:15:38PM +0200, Andreas Sturmlechner wrote:
>> > Ok, now reverted, thanks.
>> >
>> > greg k-h
>>
>> The same patch also breaks 3.0 for me. A 3.0.42 image with the patch
>> reverted was fine, I checked with several restarts.
>>
>> Sort of confirms there is something in >=3.5 that makes this thing work.
>
> Ok, Daniel, should I also revert this on 3.0.y?

/me cries

Yes.

Andreas, can you please check whether 3.5.x works for you, just to
make sure that this particular elephant is only wreaking havoc in 3.4
and earlier?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
