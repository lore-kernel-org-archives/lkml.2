Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0JHTw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:52:28 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50226 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab0JHTw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:52:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6130"; a="57221188"
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
From: Daniel Walker <dwalker@codeaurora.org>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <4CAF723B.8060202@free.fr>
References: <4CAF723B.8060202@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 12:52:21 -0700
Message-ID: <1286567541.4153.347.camel@m0nster>
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

It's hard to see what you've changed here. Could you possible make this
a delta against the original version you started with?

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


