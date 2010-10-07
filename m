Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab0JGVvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:51:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52740 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab0JGVvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:51:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6129"; a="57100852"
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
In-Reply-To: <AANLkTimPrvj=NkJ0eN5kAmRTNof1N2nfo4U-THRnqikF@mail.gmail.com>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
	 <AANLkTinxorq2XhJdGDNQuUghxzr1q6OW=S1VjupOu5nH@mail.gmail.com>
	 <1286480364.23836.17.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTi=8Et=Z6zrzbZa3L0MO=cBjjh7L=XU2=PDEbzWW@mail.gmail.com>
	 <1286481532.23836.27.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTi=j2n-X+-zkas8HdL1awo7Lcyxwofts6FjU8vj6@mail.gmail.com>
	 <1286482013.23836.29.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTinDvL9vPb6nmve3rO9dMtMAqh=d1oqBVTOHzYWH@mail.gmail.com>
	 <1286485186.23836.56.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTi==_WDX03gYRa0=qCSgZ2eoO-Uzpg66WeEX57rS@mail.gmail.com>
	 <1286486274.23836.62.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTimPrvj=NkJ0eN5kAmRTNof1N2nfo4U-THRnqikF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 14:50:50 -0700
Message-ID: <1286488250.23836.104.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 17:32 -0400, Mike Frysinger wrote:

> > Ideally you would want this driver to work in any situation .. If it's
> > setup to use ttyS0 for debugging, even if it doesn't exist, then this
> > driver would be able to stand in for that interface.
> 
> i dont think that's the case.  "any situation" is way too vague and
> invites mounds of crap to be included in the kernel which really
> should be in userspace.  ive never had a problem with my embedded work
> using ttyBF# or ttyBFJC# or ttySS# for the Blackfin serial devices,
> nor have i heard customers complain that the file absolutely must be
> named "ttyS#".  ive found that simply informing them "to use ttyBF#"
> has always been sufficient.
> -mike

It's kind of a "your milage may vary" situation .. From my perspective
it doesn't hurt anything to have an exception for this, considering what
it is used for.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

