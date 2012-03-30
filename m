Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959Ab2C3A15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 20:27:57 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44213 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933039Ab2C3A1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 20:27:51 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CA+55aFyJH8yO7=AzuddsQZouHqRDtmeh-vbd8Y5VQLQx-6ZV-Q@mail.gmail.com>
References: <1332918842-13521-1-git-send-email-olof@lixom.net>
	<1332918842-13521-2-git-send-email-olof@lixom.net>
	<20120328082501.GA22414@n2100.arm.linux.org.uk>
	<CAOesGMjwZOON9kFNvaEq8QhSvjAgsJT_J1Ysb9-AbePd6g+-rQ@mail.gmail.com>
	<20120328192816.GD22414@n2100.arm.linux.org.uk>
	<CA+55aFyJH8yO7=AzuddsQZouHqRDtmeh-vbd8Y5VQLQx-6ZV-Q@mail.gmail.com>
Date: Thu, 29 Mar 2012 17:27:50 -0700
Message-ID: <CAOesGMgaQ7mjV-1Q5uPthw8PAtU+BUfDgOqor=3jtvkL30L1ZA@mail.gmail.com>
Subject: Re: [GIT PULL 1/5] ARM: cleanups of io includes
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 5:09 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Mar 28, 2012 at 12:28 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>>
>> Right, having merged the latest arm-soc tree this evening into the build
>> tree and forced a rebuild, the errors induced by Rob's patches are now
>> gone, so I'm fine with this going in now.
>
> Ok, I'm getting back to this pull request, and apparently everything
> is ok with it.
>
> Holler if not, because it's not back on my queue of trees to merge
> (but I haven't actually gotten to it yet - this is just a heads-up
> that I will get to it later today).

I was going to send a fresh pull request for it and include some of
the other PXA breakage fixes with it, but I haven't received those
from the PXA maintainer yet. I'll send a separate pull request for a
fixes branch when I get it instead (this pull request does not add any
new breakage).

So please, go ahead and pull. It hasn't grown any new merge conflicts
since before as of now, so see the original pull request for those.


Thanks!

-Olof
