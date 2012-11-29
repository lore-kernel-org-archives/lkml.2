Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab2K2N2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 08:28:23 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:65469 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2K2N2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:28:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAKgNAkiFKPf44Q+X76TSGbR2LuyrFSWP7FLq_YdD8Twd2_25Ew@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <CAHO5Pa2_D_L6wKPWccaYH2BYWYFc=4Khe0Om5GWU3D-tcAH0OQ@mail.gmail.com>
 <CAPXgP12jXOJzTTgwQkm7XK_ig2iEKAbhgNkF+MRR6_S49Tqx_A@mail.gmail.com>
 <CA+55aFxVyqScRU_c6RWVVub-tteuwjSq5JmThUtoxU-arBuh1w@mail.gmail.com>
 <CAPXgP11teRC8bFNzF2NHJ78Bj-jf0fgRz++5vjeHVEHY=+Xe+A@mail.gmail.com>
 <1354125084.20578.1.camel@nja> <CAKgNAkiFKPf44Q+X76TSGbR2LuyrFSWP7FLq_YdD8Twd2_25Ew@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 29 Nov 2012 14:28:00 +0100
Message-ID: <CAPXgP10OW_XuPMHn=KQzaESfpNhehkUx6=hKL2dHdGytZkGmng@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: mtk.manpages@gmail.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartmann <greg@kroah.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 2:18 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> On Wed, Nov 28, 2012 at 6:51 PM, Kay Sievers <kay@vrfy.org> wrote:

>> Before:
>>   syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 286965
>>   syslog(SYSLOG_ACTION_READ_CLEAR, "<12>"..., 1000000) = 24000
>>   syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 286965
>>
>> After:
>>   syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 90402
>>   syslog(SYSLOG_ACTION_READ_CLEAR, "<5>"..., 1000000) = 90402
>>   syslog(SYSLOG_ACTION_SIZE_UNREAD, 0, 0) = 0

> I'm going to call my report yesterday bogus. Somewhere along the way,
> I got confused while testing something, and my statement about 2.6.31
> behavior is wrong: the 2.6.31 and 3.5 behaviors are the same. As such,
> your patch is unneeded. Sorry for wasting your time.

I think you have been right with your report. The above pasted
before/after from the patch commit text is actually a result of real
testing with current git. And your initial description sounds right,
and the patch seems to produce the expected results here. I just
confused the numbers in your report and wrongly parsed 2.6 > 3.6.

Hmm, at least do far we did not blame anybody else than ourselves as
confused. One of us at least is right, and it looks you have been, and
I also think the patch is at least intended to be right. :)

Kay
