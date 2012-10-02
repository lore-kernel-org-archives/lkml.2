Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2JBHRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 03:17:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60511 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab2JBHRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 03:17:23 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <6616255.1baV4zcIkN@tux200s>
References: <2372445.fuIXicT4H0@tux200s>
	<20120930143201.GA22107@kroah.com>
	<CAKMK7uE-L-+bFxJad3-pa-8i2MwvYw4_vYoWM8S-bxRmKruzoQ@mail.gmail.com>
	<6616255.1baV4zcIkN@tux200s>
Date: Tue, 2 Oct 2012 09:17:22 +0200
X-Google-Sender-Auth: XrK-x2GUVSUxGOWm2Sh9ZchKqPs
Message-ID: <CAKMK7uEuRN1WerdF1KEDzova4Qe_hY20i3N=HeNVwvRYxf6gsw@mail.gmail.com>
Subject: Re: Re: 3.4.10 i915 [GM45] regression
From: Daniel Vetter <daniel@ffwll.ch>
To: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 1, 2012 at 11:56 PM, Andreas Sturmlechner
<andreas.sturmlechner@gmail.com> wrote:
>> Andreas, can you please check whether 3.5.x works for you, just to
>> make sure that this particular elephant is only wreaking havoc in 3.4
>> and earlier?
>
> I've been using 3.5 all the time since .0, I never had any trouble there - a few reboots just now with a vanilla 3.5.4 image were
> successful as expected. Meanwhile I have upgraded to 3.6, zero issues as well.

So 3.5 and later really don't seem to have any issue with this patch.
I'm as puzzled as ever. Thanks for testing this again.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
