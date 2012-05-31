Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab2EaP00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:26:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40779 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2EaP0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:26:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1205311650130.3231@ionos>
References: <Pine.LNX.4.44L0.1205311004050.1580-100000@iolanthe.rowland.org>
	<alpine.LFD.2.02.1205311650130.3231@ionos>
Date: Thu, 31 May 2012 23:26:24 +0800
Message-ID: <CAJRGBZwEq-fHObm03qHhVhFc13kJmG+-aDnuKAKsxbmaX=NjCA@mail.gmail.com>
Subject: Re: Use of high-res timers
From: Luming Yu <luming.yu@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@redhat.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, jcm@jonmasters.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> No. ktime_get() is guaranteed to be monotonic across CPUs.
>

Hi,

We probably need a tool to enable people to test it out. I'd like to
know if you would be interested in queuing up a tool
(https://lkml.org/lkml/2012/4/10/282) for 3.5.
I've pinged someone, but not sure they have extra bandwidth or still
have interests in it.

TIA.
