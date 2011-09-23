Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab1IWS4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:56:47 -0400
Received: from void.printf.net ([89.145.121.20]:35779 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab1IWS4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:56:44 -0400
From: Chris Ball <cjb@laptop.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, Tony Lindgren <tony@atomide.com>,
        Kishore Kadiyala <kishore.kadiyala@ti.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, Balaji T K <balajitk@ti.com>,
        linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH 37/55] mmc: irq: Remove IRQF_DISABLED
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
	<1316681962-8217-38-git-send-email-yong.zhang0@gmail.com>
Date: Fri, 23 Sep 2011 14:55:57 -0400
In-Reply-To: <1316681962-8217-38-git-send-email-yong.zhang0@gmail.com> (Yong
	Zhang's message of "Thu, 22 Sep 2011 16:59:04 +0800")
Message-ID: <m2pqirw0jm.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Sep 22 2011, Yong Zhang wrote:
> Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
>
> So now this flag is a NOOP and can be removed.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks, pushed to mmc-next for 3.2 with Kishore's ACK added.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
