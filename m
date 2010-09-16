Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0IPSvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:51:09 -0400
Received: from www.tglx.de ([62.245.132.106]:54850 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab0IPSvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:51:07 -0400
Date: Thu, 16 Sep 2010 20:50:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vasily Khoruzhick <anarsoul@gmail.com>
cc: Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: Interrupt latency on some 945GM platforms
In-Reply-To: <201009162142.10629.anarsoul@gmail.com>
Message-ID: <alpine.LFD.2.00.1009162049450.2416@localhost6.localdomain6>
References: <201009132336.17310.anarsoul@gmail.com> <alpine.LFD.2.00.1009162004500.2416@localhost6.localdomain6> <201009162131.03365.anarsoul@gmail.com> <201009162142.10629.anarsoul@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-127545824-1284663051=:2416"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-127545824-1284663051=:2416
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 16 Sep 2010, Vasily Khoruzhick wrote:

> В сообщении от 16 of September 2010 21:30:58 автор Vasily Khoruzhick написал:
> > В сообщении от 16 of September 2010 21:07:39 автор Thomas Gleixner написал:
> > > > Btw, Jesse, any comments/solutions/workarounds except one with
> > > > processor.max_cstate=1 in kernel commandline? Should I file a bug on
> > > > fdo bugzilla?
> > > 
> > > we fixed a HPET related bug a few days ago, which might be the cause
> > > for your problem as well.
> > 
> > Nope, it doesn't help :(
> 
> Btw, I suspect hpet is not related, I disabled hpet completely in kernel 
> config but issue is still here (clocksource is acpi_pm)

Ok. The problematic part of HPET was not the clocksource, it was the
clock event device which failed to deliver interrupts occasionally. It
was worth a try at least.

Thanks,

	tglx
---1463795968-127545824-1284663051=:2416--
