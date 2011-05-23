Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab1EWUwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:52:17 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50395 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab1EWUwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:52:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lv96eKgFBDAGyHJmKAUp4tUAX0Dhk0CpsC0l+Yy09qqFHZD2lL4Y/eAwDrPkV+FeDF
         bCjl8KUZdSCkCXSTvrjzBHLjjRENOdfI5A8A2Cxzpe14YDvhoO8cNYJs49VEQIwbGSZM
         K/z2VEIweCgQXiUItUFSRGc+oGja0IutbPk48=
MIME-Version: 1.0
In-Reply-To: <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
	<20110523192056.GC23629@elte.hu>
	<BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
Date: Tue, 24 May 2011 00:52:14 +0400
Message-ID: <BANLkTinbrtzY66p+1NALP8BDfjXLx=Qp-A@mail.gmail.com>
Subject: Re: (Short?) merge window reminder
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 00:33, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, May 23, 2011 at 12:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> I really hope there's also a voice that tells you to wait until .42 before
>> cutting 3.0.0! :-)
>
> So I'm toying with 3.0 (and in that case, it really would be "3.0",
> not "3.0.0" - the stable team would get the third digit rather than
> the fourth one.
>
> But no, it wouldn't be for 42. Despite THHGTTG, I think "40" is a
> fairly nice round number.
>
> There's also the timing issue - since we no longer do version numbers
> based on features, but based on time, just saying "we're about to
> start the third decade" works as well as any other excuse.
>
> But we'll see.

Maybe, 2011.x, or 11.x, x increasing for every merge window started this year?
This would better reflect the steady nature of the releases, but would
certainly break a lot of scripts. ;)
