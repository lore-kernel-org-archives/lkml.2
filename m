Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab0JGUHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:07:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22917 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab0JGUHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:07:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6129"; a="57088629"
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
In-Reply-To: <AANLkTi=j2n-X+-zkas8HdL1awo7Lcyxwofts6FjU8vj6@mail.gmail.com>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
	 <AANLkTinxorq2XhJdGDNQuUghxzr1q6OW=S1VjupOu5nH@mail.gmail.com>
	 <1286480364.23836.17.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTi=8Et=Z6zrzbZa3L0MO=cBjjh7L=XU2=PDEbzWW@mail.gmail.com>
	 <1286481532.23836.27.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTi=j2n-X+-zkas8HdL1awo7Lcyxwofts6FjU8vj6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 13:06:53 -0700
Message-ID: <1286482013.23836.29.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 16:02 -0400, Mike Frysinger wrote:

> how is that any different from:
> ln -s ttyJ0 /dev/ttyS0
> -mike

It has the same major and minors as ttyS* does. So you don't have to run
anything on the target.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

