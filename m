Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1LSVFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 16:05:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50574 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab1LSVF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 16:05:29 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] MXS: Convert mutexes in clock.c to spinlocks
Date: Mon, 19 Dec 2011 22:05:25 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Shawn Guo <shawn.guo@freescale.com>, Wolfgang Denk <wd@denx.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Huang Shijie <b32955@freescale.com>,
        linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Stefano Babic <sbabic@denx.de>
References: <1324217174-6574-1-git-send-email-marek.vasut@gmail.com> <201112192154.25310.marek.vasut@gmail.com> <20111219210317.GI14542@n2100.arm.linux.org.uk>
In-Reply-To: <20111219210317.GI14542@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112192205.25806.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Dec 19, 2011 at 09:54:25PM +0100, Marek Vasut wrote:
> > > So, in summary, you have everything you require to fix it outside the
> > > driver.  You just have to decide which of the two options you want to
> > > proceed with, and actually (and finally) do it instead of endlessly
> > > procrastinating and waiting for more and more bug reports (which is
> > > exactly what has happened so far.)
> > 
> > What the hell, I just recently found this bug and I submitted a patch
> > right away! What are you complaining about?!
> 
> If you want to take that attitude to my attempt to help you understand
> the problem and see solutions, I'll ignore you permanently for being an
> absolute twit.

Go ahead, but you accused me of procrastinating and waiting even if the first 
thing I did when I saw the bug was start solving it. That's just insane!

> I'm not going to spend time giving a detailed explaination
> about the background and options over something to only then have it
> immediately shoved back in my face with such a response.

I consider my response to the last part of your email appropriate.

M
