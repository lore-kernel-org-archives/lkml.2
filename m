Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab2FKJ0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:26:36 -0400
Received: from antcom.de ([188.40.178.216]:48671 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab2FKJ0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:26:34 -0400
Message-ID: <4FD5B9C8.4020800@antcom.de>
Date: Mon, 11 Jun 2012 11:26:32 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] net: lpc_eth: Replace WARN() trace with simple pr_warn()
References: <1339401793-12258-1-git-send-email-stigge@antcom.de> <1339403108.6001.1697.camel@edumazet-glaptop> <4FD5AE1D.9030807@antcom.de> <20120611.020352.1962768244524496467.davem@davemloft.net>
In-Reply-To: <20120611.020352.1962768244524496467.davem@davemloft.net>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 06/11/2012 11:03 AM, David Miller wrote:
> From: Roland Stigge <stigge@antcom.de>
> Date: Mon, 11 Jun 2012 10:36:45 +0200
> 
>> But maybe this is wrong. Can you please give me a hint how the net
>> subsystem makes sure that this doesn't happen under normal circumstances?
> 
> Well if you are asking this question then you didn't read my feedback,
> because I explained exactly what prevents this.

Re-reading your feedback, you are right, sorry!

My question was based on the assumption that the driver is doing
correctly, which was wrong.

Thank you and Eric for clarifying!

Eric's second (cumulative) patch works fine for now, and I can't
reproduce the issue. Will do more test runs now and will reply back
later with an updated patch set.

Is it sensible at this point to increase the TX buffers anyway? For
different reasons of course: We have enough SRAM available and TX
buffers (16->32) are still more than RX buffers (48).

Roland
