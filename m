Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966010Ab2FAXG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 19:06:27 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:59958 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965935Ab2FAXG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 19:06:26 -0400
Date: Sat, 2 Jun 2012 00:57:54 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
Message-ID: <20120601225754.GA25281@electric-eye.fr.zoreil.com>
References: <20120530214809.GA19223@redhat.com> <alpine.LFD.2.02.1205310938080.3231@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1205310938080.3231@ionos>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> :
[
> So it goes idle with NET_RX softirq pending. That really should not
> happen. I fear you need to fire up the tracer :)

Can you elaborate what "should not happen" mean ? AFAIU nothing prevents
softirq to be interrupted after NET_RX processing and thus NET_RX_SOFTIRQ
to be pending again before tick_nohz_irq_exit() runs.

Dave can you:
- specify if there much traffic when the message appears
- send /proc/interrupts + ethtool -S ethX

Thanks.

-- 
Ueimor
