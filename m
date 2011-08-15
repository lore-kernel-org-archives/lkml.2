Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab1HOUrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:47:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56926 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab1HOUrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:47:45 -0400
Message-ID: <4E4985DB.20109@zytor.com>
Date: Mon, 15 Aug 2011 13:47:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Mike Waychison <mikew@google.com>, Greg KH <gregkh@suse.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Documentation: add Internal-reference-ID: patch tag
References: <20110729180028.6a2091b3.rdunlap@xenotime.net> <20110730235644.GA29671@suse.de> <CAGTjWtDXeMnHWZMmRezTSYmHr3D1N1KRXzzdjQh9HJMxvj8pwg@mail.gmail.com> <4E359A74.7090408@zytor.com> <20110813123401.76ffcfcc.rdunlap@xenotime.net> <2d50505d-3500-47d8-84d4-b32850bdec7e@email.android.com> <20110814202322.16b50ff5.rdunlap@xenotime.net> <4E48AC7D.4030908@zytor.com> <CAGTjWtD2Xz6gE6mDM6zOqDic=JZ5A9UtRzTLnUTAputc=KEZ+Q@mail.gmail.com> <4E496529.5080702@zytor.com> <20110815132331.74cd0484.rdunlap@xenotime.net>
In-Reply-To: <20110815132331.74cd0484.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 01:23 PM, Randy Dunlap wrote:
> On Mon, 15 Aug 2011 11:27:53 -0700 H. Peter Anvin wrote:
> 
>> On 08/15/2011 10:39 AM, Mike Waychison wrote:
>>>>
>>>> I would like to see the <id@owner> format I mentioned.
>>>
>>> Is there a middle ground if we say:
>>>
>>> Internal-reference-ID: <arbitrarytextforid@owner>
>>>
>>> so
>>>
>>> Internal-reference-ID: <2011.0729.id1@rdunlap>
>>> Internal-reference-ID: <bug-45322143@google>
>>>
>>
>> Personally I don't care if they are separate lines or all on the same line.
> 
> I don't understand how that answers Mike's question...
> 
Then I don't understand the question.

I proposed:

Internal-reference-ID: <2011.0729.id1@rdunlap> <33999@google>

Mike proposed:

Internal-reference-ID: <2011.0729.id1@rdunlap>
Internal-reference-ID: <bug-45322143@google>

The only difference I see is if they are on the same line, which I don't
personally care about.

	-hpa
