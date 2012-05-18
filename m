Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab2ERQVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:21:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45346 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab2ERQVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:21:04 -0400
Message-ID: <4FB676E0.9070206@zytor.com>
Date: Fri, 18 May 2012 09:20:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Re: Urgent: x86-32 and GNU ld 2.22.52.0.1
References: <4FB67146.9080804@zytor.com> <CAMe9rOqp5AUNL7Oeb2fz=nFq6Z-=hdFg_T2kc+jwkYtzOKJv9g@mail.gmail.com>
In-Reply-To: <CAMe9rOqp5AUNL7Oeb2fz=nFq6Z-=hdFg_T2kc+jwkYtzOKJv9g@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 09:14 AM, H.J. Lu wrote:
> On Fri, May 18, 2012 at 8:56 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> I need an urgent opinion.  It seems we have an epic mess on our hands.
>>
>> GNU ld 2.22.52.0.1 silently changed the semantics of section-relative
>> symbols that are part of otherwise empty sections, and silently changes
>> them to absolute.  We rely on section-relative symbols staying
>> section-relative, and actually have several sections in the linker
>> script solely for this purpose.
> 
> That is I talked to you a couple days ago:
> 
> http://sourceware.org/bugzilla/show_bug.cgi?id=14052
> 

I know, which was a very good thing... otherwise we'd probably not have
tracked this down anywhere near as quickly.  Thank you.

The problem is that this version of binutils made it into Fedora 17, and
so we now have a large number of users with a known bad binutils in the
field...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

