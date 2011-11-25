Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1KYBAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 20:00:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56419 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab1KYBAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 20:00:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 3.2-rc3 - just in time for Thanksgiving
Date: Fri, 25 Nov 2011 02:03:29 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFyNUC+k1gp3MQkxQzernEzRZwYOH4EBnOq=6UiaJ2oh4A@mail.gmail.com>
In-Reply-To: <CA+55aFyNUC+k1gp3MQkxQzernEzRZwYOH4EBnOq=6UiaJ2oh4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111250203.29786.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 24, 2011, Linus Torvalds wrote:
> Hey, since most of the US will be in a food-induced coma tomorrow, I
> just *know* that doing a new release candidate is a good idea.
> 
> One quarter arch updates, two quarters drivers, and one quarter random
> changes. Shake vigorously and serve cold..
> 
> And maybe the rest of the world can try to make up for the lack of any
> expected US participation? Hmm?

Well, unfortunately, this kernel is unusable on my Acer Ferrari One.

First off, it hangs solid every time several seconds or at last a few
minutes after boot.  I haven't been able to collect any debug data from
it yet, but one of the symptoms is black screen with (unmovable) mouse
cursor (this only happens when X has been started, but the box hangs without
X too).

Second, the wireless is apparently unable to associate with the AP
(that 3.1-rc10 works with correctly on the same box).

Tomorrow I'll try to identify the offending commits.

Thanks,
Rafael
