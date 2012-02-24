Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab2BXRVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:21:30 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:65534 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab2BXRV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:21:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jidong.xiao@gmail.com designates 10.181.13.113 as permitted sender) smtp.mail=jidong.xiao@gmail.com; dkim=pass header.i=jidong.xiao@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120224171344.GA9485@kroah.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
	<CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
	<20120224153811.GA16535@kroah.com>
	<CAG4AFWaDxK2r9W7eehAnWHxD92C_fjpL1OQnENuZFjOjXDOYmA@mail.gmail.com>
	<20120224165448.GA8751@kroah.com>
	<CAG4AFWY1a5SGA4AF9hpFrY6VE60OZUFtWmuVH92Ak_KZWs9Xtw@mail.gmail.com>
	<20120224171344.GA9485@kroah.com>
Date: Fri, 24 Feb 2012 12:21:27 -0500
Message-ID: <CAG4AFWYJj8BJq=QiNixb+tmWskgBzoPwGbREqn_s+bQkBO25ng@mail.gmail.com>
Subject: Re: Can we move device drivers into user-space?
From: Jidong Xiao <jidong.xiao@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 12:13 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Feb 24, 2012 at 12:06:54PM -0500, Jidong Xiao wrote:
>> On Fri, Feb 24, 2012 at 11:54 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> >> As to "Linux isn't a microkernel", even though the debate between
>> >> Linux and microkernel have never stopped,
>> >
>> > Um, who is having such a debate?  We aren't, so I don't think the debate
>> > has ever started.
>> >
>>
>> Here is the classic debate between Andrew S. Tanenbaum and Linus Torvalds:
>> http://en.wikipedia.org/wiki/Tanenbaum%E2%80%93Torvalds_debate
>
> That was 20 years ago, to assume that anyone rational was still having
> that debate today is insane.
>

You probably missed the second paragraph.

"This subject was revisited in 2006 after Tanenbaum wrote a cover
story for Computer magazine titled "Can We Make Operating Systems
Reliable and Secure?".[3] While Tanenbaum himself has mentioned that
he did not write the article to renew the debate on kernel design,[4]
the juxtaposition of the article and an archived copy of the 1992
debate on the technology site Slashdot caused the subject to be
rekindled.[5] Torvalds posted a rebuttal of Tanenbaum's arguments via
an online discussion forum,[6] and several technology news sites began
reporting the issue.[7] This prompted Jonathan Shapiro to respond that
most of the field-proven reliable and secure computer systems use a
more microkernel-like approach.[8]"
