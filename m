Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab1HMVbB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 17:31:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40465 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab1HMVbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 17:31:00 -0400
References: <20110729180028.6a2091b3.rdunlap@xenotime.net> <20110730235644.GA29671@suse.de> <CAGTjWtDXeMnHWZMmRezTSYmHr3D1N1KRXzzdjQh9HJMxvj8pwg@mail.gmail.com> <4E359A74.7090408@zytor.com> <20110813123401.76ffcfcc.rdunlap@xenotime.net>
User-Agent: K-9 Mail for Android
In-Reply-To: <20110813123401.76ffcfcc.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Documentation: add Internal-reference-ID: patch tag
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 13 Aug 2011 17:29:52 -0400
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Mike Waychison <mikew@google.com>, Greg KH <gregkh@suse.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <2d50505d-3500-47d8-84d4-b32850bdec7e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@xenotime.net> wrote:

>On Sun, 31 Jul 2011 11:09:56 -0700 H. Peter Anvin wrote:
>
>> On 07/31/2011 11:07 AM, Mike Waychison wrote:
>> >>>
>> >>> Internal-reference-ID: rdunlap.2011.0729.id1
>> >>>
>> > 
>> > Acked-by: Mike Waychison <mikew@google.com>
>> > 
>> 
>> Just to avoid namespace collisions, can we at least put the owner
>> somewhere standardized, e.g. <2011.0729.id1@rdunlap>, <33999@google>
>and
>> so on?
>
>I would prefer to leave the text contents as unspecified, but I
>wouldn't
>mind recommending that users try to make them unique, e.g., by using
>a company-ID or owner-ID.  Would that be acceptable?
>
>
>---
>~Randy
>*** Remember to use Documentation/SubmitChecklist when testing your
>code ***

No, that wouldn't work when there is more than one tag from different users.  And yes, I fully expect to see that.
-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
