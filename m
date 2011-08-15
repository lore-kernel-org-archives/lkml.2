Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1HOVAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:00:34 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:57281 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752333Ab1HOVAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:00:33 -0400
Date: Mon, 15 Aug 2011 14:00:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Waychison <mikew@google.com>, Greg KH <gregkh@suse.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Documentation: add Internal-reference-ID: patch tag
Message-Id: <20110815140029.f9624d57.rdunlap@xenotime.net>
In-Reply-To: <4E4985DB.20109@zytor.com>
References: <20110729180028.6a2091b3.rdunlap@xenotime.net>
	<20110730235644.GA29671@suse.de>
	<CAGTjWtDXeMnHWZMmRezTSYmHr3D1N1KRXzzdjQh9HJMxvj8pwg@mail.gmail.com>
	<4E359A74.7090408@zytor.com>
	<20110813123401.76ffcfcc.rdunlap@xenotime.net>
	<2d50505d-3500-47d8-84d4-b32850bdec7e@email.android.com>
	<20110814202322.16b50ff5.rdunlap@xenotime.net>
	<4E48AC7D.4030908@zytor.com>
	<CAGTjWtD2Xz6gE6mDM6zOqDic=JZ5A9UtRzTLnUTAputc=KEZ+Q@mail.gmail.com>
	<4E496529.5080702@zytor.com>
	<20110815132331.74cd0484.rdunlap@xenotime.net>
	<4E4985DB.20109@zytor.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011 13:47:23 -0700 H. Peter Anvin wrote:

> On 08/15/2011 01:23 PM, Randy Dunlap wrote:
> > On Mon, 15 Aug 2011 11:27:53 -0700 H. Peter Anvin wrote:
> > 
> >> On 08/15/2011 10:39 AM, Mike Waychison wrote:
> >>>>
> >>>> I would like to see the <id@owner> format I mentioned.
> >>>
> >>> Is there a middle ground if we say:
> >>>
> >>> Internal-reference-ID: <arbitrarytextforid@owner>
> >>>
> >>> so
> >>>
> >>> Internal-reference-ID: <2011.0729.id1@rdunlap>
> >>> Internal-reference-ID: <bug-45322143@google>
> >>>
> >>
> >> Personally I don't care if they are separate lines or all on the same line.
> > 
> > I don't understand how that answers Mike's question...
> > 
> Then I don't understand the question.

OK, I see.

> I proposed:
> 
> Internal-reference-ID: <2011.0729.id1@rdunlap> <33999@google>

You said (on July-31):
"Just to avoid namespace collisions, can we at least put the owner
somewhere standardized, e.g. <2011.0729.id1@rdunlap>, <33999@google> and
so on?"

I read that as 2 different patches & 2 different IDs, but this more
recent line:
> Internal-reference-ID: <2011.0729.id1@rdunlap> <33999@google>

would be for one patch with multiple IDs.


> Mike proposed:
> 
> Internal-reference-ID: <2011.0729.id1@rdunlap>
> Internal-reference-ID: <bug-45322143@google>

I think that Mike was just giving 2 examples (for 2 patches).  His proposal
was simply for:
Internal-reference-ID: <arbitrarytextforid@owner>

which matches your request fairly well AFAICT.

But if we are changing things, I think I prefer your other suggestion
for the ID tag:  "Patch-ID".  I like it because it's shorter and
easier to type.  :)


> The only difference I see is if they are on the same line, which I don't
> personally care about.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
