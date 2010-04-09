Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab0DICoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 22:44:04 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:43883 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0DICn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 22:43:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Db0K9CNOYyawINo5xt+lXxBRyHjfCiuxTq6gLGjxhG4O8CtDQVlYKy/9yp3mCY7lzU
         bwpHSoDylo1ibYdA8Xykpbw6sflLCUANnkZQHmpzhiyVKBMcSy0x/wpwLj7DgkLSC6Rg
         Jr8qKk87GFP8DUbwsjuTNzjDy68+t9+0uJK/g=
MIME-Version: 1.0
In-Reply-To: <20100408072731.GA29866@elte.hu>
References: <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
	 <alpine.LRH.2.00.1004010952080.31957@tundra.namei.org>
	 <4BB3DC4E.7030504@zytor.com>
	 <alpine.LRH.2.00.1004011042460.32618@tundra.namei.org>
	 <4BB3DF46.8080008@zytor.com>
	 <alpine.LRH.2.00.1004011200020.365@tundra.namei.org>
	 <20100401125210.GA2445@elte.hu> <20100408063236.GA23489@elte.hu>
	 <4BBD7F18.1070205@oracle.com> <20100408072731.GA29866@elte.hu>
Date: Fri, 9 Apr 2010 12:43:57 +1000
Message-ID: <n2p21d7e9971004081943qdc59e4deq315d6d06704e9f92@mail.gmail.com>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai <yinghai.lu@oracle.com>, James Morris <jmorris@namei.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       airlied@linux.ie, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 5:27 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai <yinghai.lu@oracle.com> wrote:
>
>> On 04/07/2010 11:32 PM, Ingo Molnar wrote:
>> >
>> > * Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> >> * James Morris <jmorris@namei.org> wrote:
>> >>
>> >>> On Wed, 31 Mar 2010, H. Peter Anvin wrote:
>> >>>
>> >>>> On 03/31/2010 04:43 PM, James Morris wrote:
>> >>>>>>
>> >>>>>> Upgraded how?  The problem no longer happens?
>> >>>>>
>> >>>>> Upgraded to the latest rawhide userland -- I have not since tested with
>> >>>>> bootmem off.  I'll try and do so again when I get a chance.
>> >>>>>
>> >>>>
>> >>>> That would be great.  The sooner the better, obviously.
>> >>>
>> >>> I'm not seeing any problems now, with current Linus and rawhide.  I'll leave
>> >>> bootmem off and see if anything comes up again.
>> >>
>> >> (a current bootlog would still be nice)
>> >>
>> >> Dave, can you reproduce any of these problems with Linus's latest?
>> >
>> > ping? Can you or Dave reproduce the bug with -rc3 or later kernels? (If not
>> > then it probably means that the bug you triggered was already fixed at the
>> > time you reported it, as hpa suspected.)
>>
>> James already reported -rc3 fix the problem for him.
>>
>> Dave implied -rc3 fixed problem for him
>
> Hm, i'm confused, does this mean that it was all fixed upstream already when
> Dave and James sent their complaints?

When I reported it, it was only at rc2 stage so not fixed upstream at all.

>
> Would be nice to have a confirmation from Dave for that (beyond 'implying'
> it), to not keep this thread open-ended.

Okay I built a linus head and it booted on the previously broken machine.
with CONFIG_NO_BOOTMEM=y

Dave.
