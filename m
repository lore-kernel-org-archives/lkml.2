Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1HECnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 22:43:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755720Ab1HECnM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 22:43:12 -0400
MIME-Version: 1.0
In-Reply-To: <20110805105231.7f8abe91210c30580ff40d52@canb.auug.org.au>
References: <74CDBE0F657A3D45AFBB94109FB122FF049EEAB704@HQMAIL01.nvidia.com>
 <20110805092941.136089871cddff926cf1dbb7@canb.auug.org.au> <20110805105231.7f8abe91210c30580ff40d52@canb.auug.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Aug 2011 16:42:48 -1000
Message-ID: <CA+55aFz1szgUHVLUS=gBM-+FO_PfLYPCDWFNZWZeu8M_M-cbiw@mail.gmail.com>
Subject: Re: next-200110804 ARM build break (cpuidle_call_idle)
To: Stephen Rothwell <sfr@canb.auug.org.au>, Len Brown <len.brown@intel.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 2:52 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> The last three commits in the idle tree that you took from Len were in
> linux-next until April 15 and then disappeared until yesterday.  The last
> of these was broken back then and has been committed exactly the same now
> and still breaks arm and sh.
>
> I have reverted that commit from your tree for today ...

Len, this is *exactly* why I com plained about the git trees you pushed to me.

And then I pulled anyway, because you and others convinced me things
had been in -next despite the commit dates being odd.

Let's just say that I'm really *really* disappointed. And dammit, you
need to fix your workflow. Don't add random commits late. If you're
offline, you're offline, and you send the old tested tree, not some
last-minute crap.

Next time I find reason to complain, I just won't pull.  In fact, I'm
seriously considering a rather draconian measure for next merge
window: I'll fetch the -next tree when I open the merge window, and if
I get anything but trivial fixes that don't show up in that "next tree
at the point of merge window open", I'll just ignore that pull
request. Because clearly people are just not being careful enough.

It's really *very* annoying to hear that a bug has been known about
for weeks (or months) and just not fixed, and then shows up again THE
SAME DAY that the pull request is sent to me.

                  Linus
