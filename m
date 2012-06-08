Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028Ab2FHI7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:59:47 -0400
Received: from bar.sig21.net ([80.81.252.164]:49507 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab2FHI7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:59:46 -0400
X-Greylist: delayed 1574 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jun 2012 04:59:46 EDT
Date: Fri, 8 Jun 2012 10:32:47 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Dave Jones <davej@redhat.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>,
        Marc Dionne <marc.c.dionne@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
Message-ID: <20120608083247.GA16529@sig21.net>
References: <20120530214809.GA19223@redhat.com>
 <alpine.LFD.2.02.1205310938080.3231@ionos>
 <20120601225754.GA25281@electric-eye.fr.zoreil.com>
 <CAB9dFdvWoc1onyWyy4BVmhpjeb5K2d10re0NcW-_NQCbfRC0hw@mail.gmail.com>
 <20120605231550.GA20981@electric-eye.fr.zoreil.com>
 <20120606014656.GA24870@redhat.com>
 <20120606054251.GA24467@electric-eye.fr.zoreil.com>
 <20120608023420.GD7191@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608023420.GD7191@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 10:34:20PM -0400, Dave Jones wrote:
> Ok. This was a bit of a pain to trace, as I can't trigger the NOHZ message
> when I bring up/down the interface by hand. It only seems to happen
> during boot now for some reason.

The message is only printed 10 times on each boot due to
the "ratelimit" in tick_nohz_stop_sched_tick.  I once debugged
an issue with rt2x00 (20ed3166c) and found that fairly confusing at first.

HTH
Johannes
