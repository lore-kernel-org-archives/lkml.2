Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0KCRlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:41:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753115Ab0KCRlK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:41:10 -0400
MIME-Version: 1.0
In-Reply-To: <201011030356.13878.rjw@sisk.pl>
References: <201010292358.27975.rjw@sisk.pl> <AANLkTikF+8VsxyjmXUc_6Epd923g5DCxneNArFNTGrZ_@mail.gmail.com>
 <201011030356.13878.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Nov 2010 13:40:14 -0400
Message-ID: <AANLkTikHRGkTGjBHQPt7-__XEWLYKLcSZgeXgicwOv8H@mail.gmail.com>
Subject: Re: [GIT PULL] One more power management fix for 2.6.37
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 2, 2010 at 10:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Can you boot with initcall_debug and try to suspend, please?  That should tell
> us what device this actually happens to.

It's so far only happened that once. I'm running now with
DEBUG_PAGEALLOC, DEBUG_SLUB_ON, and with initcall_debug in case it
triggers again..

> I don't even think it's necessary to suspend, it should be sufficient to do
>
> # echo devices > /sys/power/pm_test
> # echo mem > /sys/power/state
>
> Let's see if that reproduces the problem.

I'll try that a few times too.

           Linus
