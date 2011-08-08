Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab1HHFxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 01:53:39 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48523 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1HHFxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 01:53:36 -0400
Date: Sun, 07 Aug 2011 22:53:32 -0700 (PDT)
Message-Id: <20110807.225332.1987773233464471729.davem@davemloft.net>
To: richardcochran@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/2] gianfar: fix fiper alignment after resetting the
 time
From: David Miller <davem@davemloft.net>
In-Reply-To: <018b1f12e792c4758d1e601742f758a09dd10d62.1312699694.git.richard.cochran@omicron.at>
References: <cover.1312699693.git.richard.cochran@omicron.at>
	<cover.1312699693.git.richard.cochran@omicron.at>
	<018b1f12e792c4758d1e601742f758a09dd10d62.1312699694.git.richard.cochran@omicron.at>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 07 Aug 2011 22:53:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Sun,  7 Aug 2011 09:03:03 +0200

> After resetting the time, the PPS signals on the FIPER output channels
> are incorrectly offset from the clock time, as can be readily verified
> by a looping back the FIPER to the external time stamp input.
> 
> Despite its name, setting the "Fiper Realignment Disable" bit seems to
> fix the problem, at least on the P2020.
> 
> Also, following the example code from the Freescale BSP, it is not really
> necessary to disable and re-enable the timer in order to reprogram the
> FIPER. (The documentation is rather unclear on this point. It seems that
> writing to the alarm register also disables the FIPER.)
> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
> Cc: <stable@kernel.org>

Applied.
