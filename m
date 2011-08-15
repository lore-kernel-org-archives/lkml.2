Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1HOWNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 18:13:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41402 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab1HOWNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 18:13:18 -0400
Message-ID: <4E4999EA.5060603@zytor.com>
Date: Mon, 15 Aug 2011 15:12:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Mike Waychison <mikew@google.com>, Greg KH <gregkh@suse.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Documentation: add Internal-reference-ID: patch tag
References: <20110729180028.6a2091b3.rdunlap@xenotime.net> <20110730235644.GA29671@suse.de> <CAGTjWtDXeMnHWZMmRezTSYmHr3D1N1KRXzzdjQh9HJMxvj8pwg@mail.gmail.com> <4E359A74.7090408@zytor.com> <20110813123401.76ffcfcc.rdunlap@xenotime.net> <2d50505d-3500-47d8-84d4-b32850bdec7e@email.android.com> <20110814202322.16b50ff5.rdunlap@xenotime.net> <4E48AC7D.4030908@zytor.com> <CAGTjWtD2Xz6gE6mDM6zOqDic=JZ5A9UtRzTLnUTAputc=KEZ+Q@mail.gmail.com> <4E496529.5080702@zytor.com> <20110815132331.74cd0484.rdunlap@xenotime.net> <4E4985DB.20109@zytor.com> <20110815140029.f9624d57.rdunlap@xenotime.net>
In-Reply-To: <20110815140029.f9624d57.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 02:00 PM, Randy Dunlap wrote:
> 
> You said (on July-31):
> "Just to avoid namespace collisions, can we at least put the owner
> somewhere standardized, e.g. <2011.0729.id1@rdunlap>, <33999@google> and
> so on?"
> 
> I read that as 2 different patches & 2 different IDs, but this more
> recent line:
>> Internal-reference-ID: <2011.0729.id1@rdunlap> <33999@google>
> 
> would be for one patch with multiple IDs.
> 
>> Mike proposed:
>>
>> Internal-reference-ID: <2011.0729.id1@rdunlap>
>> Internal-reference-ID: <bug-45322143@google>
> 
> I think that Mike was just giving 2 examples (for 2 patches).  His proposal
> was simply for:
> Internal-reference-ID: <arbitrarytextforid@owner>
> 
> which matches your request fairly well AFAICT.
> 

Yes, that was my request.  But I also do observe that a single patch can
be tracked in multiple internal databases; for example, if
(hypothetically) Red Hat reports a bug to Google which ends up being
tracked in both bug databases, they may both want to tag the same patch.

> But if we are changing things, I think I prefer your other suggestion
> for the ID tag:  "Patch-ID".  I like it because it's shorter and
> easier to type.  :)

Agreed.

	-hpa

