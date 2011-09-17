Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab1IQBJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 21:09:08 -0400
Received: from 184-106-247-128.static.cloud-ips.com ([184.106.247.128]:38294
	"EHLO cloud01.chad-versace.us" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932362Ab1IQBJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 21:09:07 -0400
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Sep 2011 21:09:07 EDT
X-Spam-Flag: NO
X-Spam-Score: -1
Date: Fri, 16 Sep 2011 18:01:02 -0700
From: Ben Widawsky <ben@bwidawsk.net>
To: "Keith Packard" <keithp@keithp.com>
Cc: airlied@gmail.com, Akshay Joshi <me@akshayjoshi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: Whitespace cleanups in drm/i915
Message-ID: <20110916180102.79997d61@bwidawsk.net>
In-Reply-To: <yun8vppw9lu.fsf@aiko.keithp.com>
References: <yun8vppw9lu.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011 18:37:33 -0700
"Keith Packard" <keithp@keithp.com> wrote:

> 
> I've got this nice patch from Akshay Joshi that removes almost all of
> the checkpatch.pl warnings from drm/i915. If I don't merge it now,
> it's going to go stale and be useless; if I merge it only to
> drm-intel-next, it will be the source of endless conflicts.
> 
> However, it's a huge patch (yes, the code was rather sloppy), and
> doesn't exactly fit into the "critical patches only please" mode of
> the current stage of 3.1 development.
> 
> I've checked the patch very carefully, using the obvious git diff -b
> to make sure it really doesn't touch anything but whitespace, but also
> using objdump -s to compare the output of the compiler. There were no
> differences found with git-diff -b. The only differences found by
> objdump are two whitespace changes in some debug output messages in
> intel_bios.c.
> 
> I think I have three choices:
> 
>  1) merge the patch and expect complaints from upstream
> 
>  2) thank Akshay for his good intentions, discard the patch and hope
>     that he feels motivated enough to do it all over again in time for
>     the 3.2 merge window.
> 
>  3) thank Akshay for his good intentions and leave the code as-is,
>     forever to ease back-porting of fixes to older kernel versions.
> 
> Frankly, if we're ever going to merge whitespace fixups, this would
> be a pretty darn good time; drm-intel-fixes and drm-intel-next are
> in-sync as I haven't started pulling 3.2 code into -next.
> 

Not that you asked for a vote, but I vote either 1, or 3. In that order.
Let's either do it now, or never, and have the code slowly migrate over time
(kind of like Daniel said).

My only concern is the 80 characters per line rule. I'd hate to see some of
those nice readable lines go just because it's > 80.

Ben
