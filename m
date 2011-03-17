Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab1CQAdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:33:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752242Ab1CQAc6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 20:32:58 -0400
MIME-Version: 1.0
In-Reply-To: <20110317002818.GA19812@kroah.com>
References: <20110316210300.GA3311@kroah.com> <AANLkTim13aZ0Mr5RrOeQizHGY3jhf97x8v9mznY8RqgE@mail.gmail.com>
 <20110317002818.GA19812@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Mar 2011 17:32:00 -0700
Message-ID: <AANLkTikEEDDFxZQtvV46JJRU1NAtiXh_N4onJ1jwKHaF@mail.gmail.com>
Subject: Re: [GIT PATCH] STAGING patches for .39
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 5:28 PM, Greg KH <greg@kroah.com> wrote:
>>
>> Aren't those things supposed to at least compile? What's going on?
>
> The gma500 driver will not build until you pull the drm tree into yours
> as that is an api dependancy it needs.  I didn't think you build staging
> drivers, so I didn't think I needed to call this one out.  I was wrong :)

I don't try to compile the staging tree all the time, but I do tend to
try to check it every once in a while. So yes, let me know if there
are dependencies.

> As for the others, I don't know of any build problems, what one did you
> have a problem with?

The one with inifinite errors was vt6655.

It may be due to network layer changes. I had some other drivers with
conflicts. Maybe this one didn't have content conflicts, but ended up
having conflicts due to changed semantics etc.

                 Linus
