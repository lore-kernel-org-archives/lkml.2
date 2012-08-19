Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2HSNeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 09:34:12 -0400
Received: from mail.nonattached.net ([193.160.39.60]:55177 "EHLO
	mail.nonattached.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2HSNeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 09:34:08 -0400
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
From: Dan Luedtke <mail@danrl.de>
To: Jochen Striepe <jochen@tolot.escape.de>
Cc: Marco Stornelli <marco.stornelli@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, lanyfs@librelist.com
In-Reply-To: <20120819120254.GA2369@pompeji.miese-zwerge.org>
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
	 <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
	 <1345371135.4441.2.camel@tunafish> <5030BC7E.3030000@gmail.com>
	 <1345383264.4441.56.camel@tunafish>
	 <20120819120254.GA2369@pompeji.miese-zwerge.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Aug 2012 17:33:52 +0200
Message-ID: <1345390432.2716.34.camel@tunafish>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-19 at 14:02 +0200, Jochen Striepe wrote:
> You wrote a new fs just because you didn't bother to use the existing
> ones as intended?
You are over-estimating my motivation.
I use many fs as intended, and they do a great job. I would not replace
them, not on my workstation and not on my servers. But from time to time
I get into trouble when I start transferring data from system A to
system B by using removable storage devices. While this can be solved as
long as I know what the target platform/os will be, it becomes more
difficult when the target platform/os is unknown.

Poorly crafted example:
Let's say you have a 6GB video file you want to give somebody (e.g. a
video cutter) on a thumb drive. The cutter wants to edit the file, so he
needs read and write access to it. After cutting the file is to be
played on a TV screen with USB-port. What if the cutter does use two
different, major, non-Linux operating systems, let's say one for cutting
and the other one for adding visual effects? Now imagine the cutter (and
of course the TV screen vendor) don't care much about filesystems as
they are just generating costs (implementation), so it will only come
with minimal compatibility.
- What filesystem would you recommend to share that video file?


There is a small niche which LanyFS tries to fit in. It is for those who
do not want to bother about how to use a fs when they are in a hurry or
when they just want to listen to music in the car. It is for the
it-must-be-easy-enough-for-my-gradma fraction. It is for those who think
that data stored on a thumb drive intended for use with
unknown/untrusted/undocumented systems should not be critical data
anyway. I do not recommend storing vital files or data worth protecting
from unauthorized modification/access on a "highly mobile" thumb drive,
especially not one formatted with LanyFS. After all, it is a fs that
tries to grant access to the data at any cost*.

Still wondering if anyone bothers to actually look at the code?
Although I appreciate any feedback about why-would-one-even-write-a-fs,
I would also be very happy about comments that help improve the code.

regards,
Dan


*This one is worth a discussion, but LKML might not be the right place?
-- 
Dan Luedtke
http://www.danrl.de

