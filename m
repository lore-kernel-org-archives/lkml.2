Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1BVTx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:53:27 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36776 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab1BVTx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:53:26 -0500
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
 rtc_class_ops->read_alarm()
From: john stultz <johnstul@us.ibm.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
In-Reply-To: <20110222181647.GA25569@opensource.wolfsonmicro.com>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
	 <1298332538-31216-5-git-send-email-john.stultz@linaro.org>
	 <20110222023452.GB18299@sirena.org.uk> <1298343333.4222.36.camel@work-vm>
	 <1298362178.4222.57.camel@work-vm>
	 <20110222181647.GA25569@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Feb 2011 11:53:19 -0800
Message-ID: <1298404399.9215.42.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 10:16 -0800, Mark Brown wrote:
> On Tue, Feb 22, 2011 at 12:09:38AM -0800, john stultz wrote:
> 
> > Just so I can better get a grip of the cases your considering, could you
> > maybe give me some more detailed examples of where you'd like to see the
> > alarm timer be set and then persist across multiple power cycles before
> > firing? And how is that persistent value managed by the application
> > setting it?
> 
> The WM83xx RTCs can do this (the alarm can be used to initiate a boot)
> and I'd expect many embedded RTC controllers can do similar.

Oh, and would you be able to test the possible solution I have for this?
Since the hardware I have doesn't support alarm persistence across
reset, I'm limited in being able to validate the patch's correctness. 

thanks
-john


