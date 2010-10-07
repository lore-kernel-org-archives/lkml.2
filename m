Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab0JGUhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:37:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58879 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0JGUhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:37:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6129"; a="56986404"
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
From: Daniel Walker <dwalker@codeaurora.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
In-Reply-To: <20101007215202.65ffeace@lxorguk.ukuu.org.uk>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
	 <AANLkTinxorq2XhJdGDNQuUghxzr1q6OW=S1VjupOu5nH@mail.gmail.com>
	 <20101007215202.65ffeace@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 13:37:11 -0700
Message-ID: <1286483831.23836.40.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 21:52 +0100, Alan Cox wrote:
> On Thu, 7 Oct 2010 15:25:34 -0400
> Mike Frysinger <vapier@gentoo.org> wrote:
> 
> > On Thu, Oct 7, 2010 at 14:36, Daniel Walker wrote:
> > > Many of JTAG debuggers for ARM support DCC protocol over JTAG
> > > connection, which is very useful to debug hardwares which has no
> > > serial port. This patch adds DCC serial emulation and the console
> > > support. System timer based polling method is used for the
> > > emulation of serial input interrupt handling.
> > 
> > why use serial_core at all ?  seems like you could just use the tty
> > layer directly.  i did that with drivers/char/bfin_jtag_comm.c.
> 
> I would agree 100% with this for the driver in question. The tty_port
> helpers now make it trivial to do so and it'll be small and clean as a
> result.

Can you give some example of other drivers which have done this?

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

