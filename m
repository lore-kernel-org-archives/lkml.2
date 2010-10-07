Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0JGTjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 15:39:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62121 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab0JGTju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 15:39:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6129"; a="56980492"
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
From: Daniel Walker <dwalker@codeaurora.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
In-Reply-To: <AANLkTinxorq2XhJdGDNQuUghxzr1q6OW=S1VjupOu5nH@mail.gmail.com>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
	 <AANLkTinxorq2XhJdGDNQuUghxzr1q6OW=S1VjupOu5nH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 12:39:24 -0700
Message-ID: <1286480364.23836.17.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 15:25 -0400, Mike Frysinger wrote:
> On Thu, Oct 7, 2010 at 14:36, Daniel Walker wrote:
> > Many of JTAG debuggers for ARM support DCC protocol over JTAG
> > connection, which is very useful to debug hardwares which has no
> > serial port. This patch adds DCC serial emulation and the console
> > support. System timer based polling method is used for the
> > emulation of serial input interrupt handling.
> 
> why use serial_core at all ?  seems like you could just use the tty
> layer directly.  i did that with drivers/char/bfin_jtag_comm.c.
> 
> although, there's the suggestion in the air that my jtag driver could
> be converted to the HVC framework to even further simplify things.
> but no one thinks it should be serial_core :).
> -mike

It will actually create a serial port on ttyS* if you want it to.. It
could be debatable if that's useful, but I didn't rip that out because
Hyok had that in his original code (he thought it was useful) ..

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

