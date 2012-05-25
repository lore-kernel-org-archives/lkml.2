Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab2EYIa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:30:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36053 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352Ab2EYIaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:30:55 -0400
MIME-Version: 1.0
In-Reply-To: <CA+1xoqfCQutidqdwb3ysCtajHF2r0zNLc4H+X7cYpxrmjoqAvg@mail.gmail.com>
References: <20120523002645.GA3490@redhat.com>
	<CACVXFVMz_GKHXpzbqt24yY=fHJ6uYZPOcSnKNFHrvbdpWxc7tw@mail.gmail.com>
	<CA+1xoqf0G3kDY3c4Gb=RkQZ8_L+but6-uUjtSVfvYUf6iL2_JA@mail.gmail.com>
	<20120524121056.24fbdcdb@pyramind.ukuu.org.uk>
	<CA+1xoqegLYLsP5yWw7d7oMngUSgZjXePJu_b6E-yw4aBE8Qhgg@mail.gmail.com>
	<CA+1xoqc3MrwfDnf9iCRLCedapZOtOfmBb6E84ORgwmdP1fx8QA@mail.gmail.com>
	<CA+1xoqeD3yyOgmLe_eQ_PS=HJA=93Syidtk6rq-K9dBoC-DOzQ@mail.gmail.com>
	<20120524155457.56e37df2@bob.linux.org.uk>
	<20120525023222.GC30024@home.goodmis.org>
	<CA+1xoqfCQutidqdwb3ysCtajHF2r0zNLc4H+X7cYpxrmjoqAvg@mail.gmail.com>
Date: Fri, 25 May 2012 16:30:55 +0800
Message-ID: <CACVXFVNB+=EniGofYV2eMy8m521aNbs4MJETEFEwTK7LMpK6LA@mail.gmail.com>
Subject: Re: 3.4+ tty lockdep trace
From: Ming Lei <tom.leiming@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Alan Cox <alan@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 4:07 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Fri, May 25, 2012 at 4:32 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Thu, May 24, 2012 at 03:54:57PM +0100, Alan Cox wrote:
>>> On Thu, 24 May 2012 13:24:56 +0200
>>> Sasha Levin <levinsasha928@gmail.com> wrote:
>>> >
>>> > And here is the second one attached as well, so these are two
>>> > different warnings I get with the new version.
>>>
>>>
>>> I'm somewhat baffled by this one. Can lockdep be fooled by an object
>>> being freed and reallocated at the same address, Is there any markup
>>> that should be present to avoid that ?
>>
>> Sasha,
>>
>> Did you apply Ming's second patch. His first patch (the one referenced
>> in the email) didn't have the unlock fixup.
>
> Nope, I just got the first one.
>
> What's the right patchset to use atm? I know about these patches from
> Ming, and I see Alan sent out two patches yesterday. Which ones should
> I use for testing?

You can try to apply my 2nd patch against Alan's two patches for the tests.


Thanks,
-- 
Ming Lei
