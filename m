Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424854Ab2LFV2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 16:28:20 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58282 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424822Ab2LFV2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 16:28:18 -0500
MIME-Version: 1.0
In-Reply-To: <20121206160052.GB32620@linux-mips.org>
References: <20121206160052.GB32620@linux-mips.org>
Date: Thu, 6 Dec 2012 15:28:17 -0600
Message-ID: <CACoURw7JTFMzmcRZHmBchcWPC8x5LFFfC1nGH-Xxc8f3KjNE2Q@mail.gmail.com>
Subject: Re: RM9000 / E9000, MSP71xx class processors, SOCs and eval boards
From: Shane McDonald <mcdonald.shane@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips <linux-mips@linux-mips.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 6, 2012 at 10:00 AM, Ralf Baechle <ralf@linux-mips.org> wrote:
> Folks,
>
> since many years the support code for those devices is rusting away in
> the lmo git tree and frankly, I'd get rid of it because there's been
> very few patch submissions or any kind of indication that somebody
> still cares.  In short, this has turned into a waste of resource not
> least my time.
>
> So, is anybody still interested in maintaining that code?  If so, you
> better attach a bunch of patches to your reply.
>
>   Ralf
>

I'm interested in the MSP71xx eval board, although I may be
the only person in the world who cares.  Specifically, I use the
msp71xx_defconfig.  3.7-rc8 compiles with gcc-4.6.3
without requiring any patches.

I don't know when the last time the RM9000 was compilable,
but I have no interest in that, nor do I have interest in the
FPGA or eval board versions of the MSP7120 (no hardware to
test with).

I had hoped that someone from PMC-Sierra would respond, but
maybe they don't care anymore...

Shane McDonald
