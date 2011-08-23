Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab1HWQUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 12:20:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45661 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1HWQUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 12:20:24 -0400
MIME-Version: 1.0
In-Reply-To: <4E53D145.7070207@linux.intel.com>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
	<CA+55aFwEgp=3F6uH198XuQR0=6Um-Kp+0Wjcm0Xv1WoHRveKXw@mail.gmail.com>
	<CADkLE3Ux1gVBR0f1VUNP4JDsnDQPUQ8rJrXqPV7-2kdLW0_CCw@mail.gmail.com>
	<4E53D145.7070207@linux.intel.com>
Date: Tue, 23 Aug 2011 12:20:23 -0400
X-Google-Sender-Auth: oYyNwZDIPrIOYLiZGEd6kxNTmvc
Message-ID: <CADkLE3X82um14wFnisPBtB=PLCX4A9JPVMXmdqdNusfhVAjq2A@mail.gmail.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
From: Colin Walters <walters@verbum.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 12:11 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
> That's a good point. I googled for this pattern in google codesearch
> and there are 10+ in the first two pages.
>
> http://www.google.com/codesearch#search/&q=lang:^python$%20sys.platform%20linux2&p=1&type=cs

Yes, though I should note I wasn't trying to defend having a
compatibility sysctl or whatever - I think it's clear these apps are
broken.  The python docs explicitly say that the returned string is
just a straightforward transformation of uname, and if the apps read
that carefully they'd realize they only want the first part.

The reportlab example will break for FreeBSD 5 too:

     elif sys.platform in ("freebsd4", "darwin", "mac", "linux2"):

I just happen to watch Mozilla bugzilla so I saw that one go by and
wanted to provide data for the discussion.
