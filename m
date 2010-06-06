Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab0FFPt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 11:49:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51394 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758055Ab0FFPtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 11:49:23 -0400
Date: Sun, 6 Jun 2010 19:22:35 +0530
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.35-rc2
Message-ID: <20100606135233.GA13688@himanshu-laptop>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
 <AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The first problem that shows up is, that after the KMS switches to the
> correct video mode (1280x1024 for an DVI attached LCD), the display
> begins to flicker. Every 1..2 seconds (guesstimated) the display turns
> off and on again. Something in the new powersaving?
> 
> This keeps up during userspace bootup, but probably around the time
> Xorg starts the display goes blank and does not come back on. I'm not
> sure if this final part is really a bug with KMS/radeon/Xorg because
> the system died at that point because of the second problem with
> 2.6.35-rc2, but I wanted to mention it anyway.

Same is the case with me. I have an Acer aspire 3000 and a assembled Pentium 4
machine. Both show the same behaviour. Monitor flickers, display turns off,
and never turns back on. X doesn't always start correctly. I need to do, CTRL_ALT_F2
 and CTRL_ALT_F7 couple of times before I get it working again.

- Himanshu
