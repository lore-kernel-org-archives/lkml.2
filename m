Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab0GLTvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 15:51:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42477 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab0GLTvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 15:51:08 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTim-O00n9YPv7w4VCKjN-ETLijyTHomWUn4mZtTV@mail.gmail.com>
References: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> 
	<20100603181010.GA25779@flint.arm.linux.org.uk> <1275589230.23384.19.camel@c-dwalke-linux.qualcomm.com> 
	<alpine.LFD.2.00.1006031119440.8175@i5.linux-foundation.org> 
	<20100614083214.GA2104@pengutronix.de> <20100630104043.GG11746@pengutronix.de> 
	<20100712155518.GA24144@pengutronix.de> <AANLkTilhI9O6YwnuAylo_jNgwR8VXmpSVJ1kylIYPCGT@mail.gmail.com> 
	<20100712173228.GC9897@n2100.arm.linux.org.uk> <AANLkTinxUqzxClVDTyruJ6kzFTganXUGJJHJ5wRi9Iak@mail.gmail.com> 
	<20100712185029.GB14425@pengutronix.de> <AANLkTinOuU-VVXaMwMp69CBp2Y4wxpoWybEQ34H5j0lJ@mail.gmail.com> 
	<alpine.LFD.2.00.1007121510260.10598@xanadu.home> <AANLkTim-O00n9YPv7w4VCKjN-ETLijyTHomWUn4mZtTV@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 12 Jul 2010 13:50:47 -0600
X-Google-Sender-Auth: Cq_TwMCssr0v-m4NC4ZrGwcoirA
Message-ID: <AANLkTilDoGbCx_0oKKPOeGG7TKL2VSNVII5ydmnQ77B7@mail.gmail.com>
Subject: Re: ARM defconfig files
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Pitre <nico@fluxnic.net>, Daniel Walker <dwalker@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Eric Miao <eric.miao@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 1:34 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jul 12, 2010 at 12:17 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
>> I think Uwe could provide his script and add it to the kernel tree.
>> Then all architectures could benefit from it.  Having the defconfig
>> files contain only those options which are different from the defaults
>> is certainly more readable, even on x86.
>
> Quite possible. But maintainers would need to be on the lookout of
> people actually using the script, and refusing to apply patches that
> re-introduce the whole big thing.

I can (partially) speak for powerpc.  If ARM uses this approach, then
I think we can do the same.  After the defconfigs are trimmed, I
certainly won't pick up any more full defconfigs.

Of course, I'm also operating under the assumption that this is a
temporary measure until one of the better solutions is implemented.  I
do suspect that the trimmed defconfigs will tend to be unstable and
will still require manual maintenance.  I think the Kconfig fragments
approach is the most promising if the dependencies issue can be
solved.

g.
