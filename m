Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab0JHTzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:55:20 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25209 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab0JHTzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:55:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6130"; a="57221688"
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
From: Daniel Walker <dwalker@codeaurora.org>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <4CAF723B.8060202@free.fr>
References: <4CAF723B.8060202@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 12:55:18 -0700
Message-ID: <1286567718.4153.352.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 21:34 +0200, matthieu castet wrote:
> Hi,
> 
> for the record I attach a modified version of the original samsung one that I did.
> 
> I improved a bit the reactivity, and did some hack to make polling in idle loop.
> With recent kernel this should be done in a thread with SCHED_IDLE policy.
> 
> I also supported board with irq for rx and tx (not sure if the original driver supported it).

Do you use the CONFIG_SERIAL_DCC_STDSERIAL feature?

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


