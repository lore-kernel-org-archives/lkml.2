Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab0INWlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:41:23 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:43069 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0INWlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:41:22 -0400
Date: Tue, 14 Sep 2010 23:41:11 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: Interrupt latency on some 945GM platforms
Message-ID: <20100914224111.GA14467@sucs.org>
References: <201009132336.17310.anarsoul@gmail.com> <201009141109.41596.anarsoul@gmail.com> <alpine.LFD.2.00.1009141149380.2416@localhost6.localdomain6> <201009141529.53179.anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201009141529.53179.anarsoul@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 03:29:48PM +0300, Vasily Khoruzhick wrote:
> В сообщении от 14 of September 2010 12:52:57 автор Thomas Gleixner написал:
> > Can you try with NOHZ enabled and the following on the kernel command line:
> > 
> >     processor.max_cstate=1
> 
> It works in this case (gears in glxgears move smoothly)
>  
> > If that works, then try
> > 
> >     processor.max_cstate=2
> > 
> 
> Nope, it doesn't work with max_cstate=2

Perhaps intel_idle is being used? Any mention of it in dmesg?

-- 
Sitsofe | http://sucs.org/~sits/
