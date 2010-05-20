Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab0ETBv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 21:51:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43675 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab0ETBv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 21:51:56 -0400
Message-ID: <4BF495B6.6030804@infradead.org>
Date: Wed, 19 May 2010 22:51:50 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
References: <20100520114543.898f02c7.sfr@canb.auug.org.au>
In-Reply-To: <20100520114543.898f02c7.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Mauro,
> 
> After merging the v4l-dvb tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/input/evdev.c: In function 'evdev_do_ioctl':
> drivers/input/evdev.c:596: error: duplicate case value
> drivers/input/evdev.c:574: error: previously used here
> 
> Caused by commit ff2956560d97ccdd2c54cb9d0fdd7eb78c113ba9 ("V4L/DVB:
> input: Add support for EVIO[CS]GKEYCODEBIG").
> 
> Please build test.
> 
> I have used the v4l-dvb tree from next-20100519 for today.

Yeah, I noticed that. It was due to a bad merge conflict I did. As there's
a bug at the new big getkeycode, I've removed those input changes from
linux-next for a while, since I wanted to send upstream the patches
that I currently have. I've already pushed the new version.

I'll probably add later the input patches, if I can fix the bug today.

-- 

Cheers,
Mauro
