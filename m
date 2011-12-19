Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab1LSVD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 16:03:56 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57890 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab1LSVDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 16:03:54 -0500
Date: Mon, 19 Dec 2011 21:03:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Shawn Guo <shawn.guo@freescale.com>, Wolfgang Denk <wd@denx.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Huang Shijie <b32955@freescale.com>,
        linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Stefano Babic <sbabic@denx.de>
Subject: Re: [PATCH] MXS: Convert mutexes in clock.c to spinlocks
Message-ID: <20111219210317.GI14542@n2100.arm.linux.org.uk>
References: <1324217174-6574-1-git-send-email-marek.vasut@gmail.com> <201112191257.06145.marek.vasut@gmail.com> <20111219121559.GF14542@n2100.arm.linux.org.uk> <201112192154.25310.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112192154.25310.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 09:54:25PM +0100, Marek Vasut wrote:
> > So, in summary, you have everything you require to fix it outside the
> > driver.  You just have to decide which of the two options you want to
> > proceed with, and actually (and finally) do it instead of endlessly
> > procrastinating and waiting for more and more bug reports (which is
> > exactly what has happened so far.)
> 
> What the hell, I just recently found this bug and I submitted a patch right 
> away! What are you complaining about?!

If you want to take that attitude to my attempt to help you understand
the problem and see solutions, I'll ignore you permanently for being an
absolute twit.  I'm not going to spend time giving a detailed explaination
about the background and options over something to only then have it
immediately shoved back in my face with such a response.
