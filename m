Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab3ADXLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 18:11:53 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41748 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab3ADXLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 18:11:51 -0500
Date: Fri, 04 Jan 2013 15:11:46 -0800 (PST)
Message-Id: <20130104.151146.1432785010798255784.davem@davemloft.net>
To: peterhuewe@gmx.de
Cc: mcarlson@broadcom.com, nsujir@broadcom.com, mchan@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com, kbuild@01.org
Subject: Re: [PATCH net-next/master] ethernet/broadcom/tg3: Fix sparse
 warning: constant 0x7fffffffffffffff is so big it is long long
From: David Miller <davem@davemloft.net>
In-Reply-To: <1357223030-29155-1-git-send-email-peterhuewe@gmx.de>
References: <50beaf6a.HF5L0P4z6BqrUx/x%fengguang.wu@intel.com>
	<1357223030-29155-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Thu,  3 Jan 2013 15:23:50 +0100

> Sparse complains that:
> drivers/net/ethernet/broadcom/tg3.c:5670:55: sparse: constant
> 0x7fffffffffffffff is so big it is long long (on x86/32 bit)
> 
> so we suffix the constant with LL in the header file.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Applied.
