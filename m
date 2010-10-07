Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0JGVAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:00:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46275 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab0JGVAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:00:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6129"; a="57094225"
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
In-Reply-To: <AANLkTinDvL9vPb6nmve3rO9dMtMAqh=d1oqBVTOHzYWH@mail.gmail.com>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
	 <AANLkTinxorq2XhJdGDNQuUghxzr1q6OW=S1VjupOu5nH@mail.gmail.com>
	 <1286480364.23836.17.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTi=8Et=Z6zrzbZa3L0MO=cBjjh7L=XU2=PDEbzWW@mail.gmail.com>
	 <1286481532.23836.27.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTi=j2n-X+-zkas8HdL1awo7Lcyxwofts6FjU8vj6@mail.gmail.com>
	 <1286482013.23836.29.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTinDvL9vPb6nmve3rO9dMtMAqh=d1oqBVTOHzYWH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 13:59:46 -0700
Message-ID: <1286485186.23836.56.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 16:47 -0400, Mike Frysinger wrote:
> On Thu, Oct 7, 2010 at 16:06, Daniel Walker wrote:
> > On Thu, 2010-10-07 at 16:02 -0400, Mike Frysinger wrote:
> >> how is that any different from:
> >> ln -s ttyJ0 /dev/ttyS0
> >
> > It has the same major and minors as ttyS* does. So you don't have to run
> > anything on the target.
> 
> i dont see how those things are related.  the major/minor are
> irrelevant, unless you've already hard coded these in some app that
> creates device nodes manually (instead of mdev/udev), but even then
> that's something that "needs to be run on the target".  and both
> already have config support to transparently do something like
> "symlink ttyS# to XXX" as XXX is created.

Something does ultimately run on all targets, the issues is does the
person debugging have the ability to change it .. It's not always the
case that they can change it. The userspace may not have udev at all.
The userspace may consist of a single binary .. I'm not making any
assumptions about the userspace here, it can be anything.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

