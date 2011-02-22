Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab1BVUbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:31:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33883 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751067Ab1BVUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:31:44 -0500
Date: Tue, 22 Feb 2011 20:31:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: john stultz <johnstul@us.ibm.com>
Cc: rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
	rtc_class_ops->read_alarm()
Message-ID: <20110222203143.GE31611@opensource.wolfsonmicro.com>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org> <1298332538-31216-5-git-send-email-john.stultz@linaro.org> <20110222023452.GB18299@sirena.org.uk> <1298343333.4222.36.camel@work-vm> <1298362178.4222.57.camel@work-vm> <20110222181647.GA25569@opensource.wolfsonmicro.com> <1298404399.9215.42.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298404399.9215.42.camel@work-vm>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 11:53:19AM -0800, john stultz wrote:
> On Tue, 2011-02-22 at 10:16 -0800, Mark Brown wrote:

> > The WM83xx RTCs can do this (the alarm can be used to initiate a boot)
> > and I'd expect many embedded RTC controllers can do similar.

> Oh, and would you be able to test the possible solution I have for this?
> Since the hardware I have doesn't support alarm persistence across
> reset, I'm limited in being able to validate the patch's correctness. 

I should be able to I think, I'll need to check that I've got a board
which can go down to full power off without cutting the RTC supply but
I'm pretty sure I do.
