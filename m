Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab2HLUm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 16:42:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37120 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2HLUm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 16:42:26 -0400
Date: Sun, 12 Aug 2012 13:42:25 -0700 (PDT)
Message-Id: <20120812.134225.1778015851322929441.davem@davemloft.net>
To: yuvalmin@broadcom.com
Cc: joren.vanonder@gmail.com, eilong@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2x: Fix compiler warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <50273628.50503@broadcom.com>
References: <1344741035-1493-1-git-send-email-joren.vanonder@gmail.com>
	<50273628.50503@broadcom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yuval Mintz" <yuvalmin@broadcom.com>
Date: Sun, 12 Aug 2012 07:50:48 +0300

>> Fix the following compiler warnings:
>> 
>>  - drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:2908:3: warning: comparison
>>    of distinct pointer types lacks a cast [enabled by default]
>>  - drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:1709:7: warning: comparison
>>    of distinct pointer types lacks a cast [enabled by default]
>> 
>> Signed-off-by: Joren Van Onder <joren.vanonder@gmail.com>
> Thanks Joren.
> Acked-By: Yuval Mintz <yuvalmin@broadcom.com>

Applied.
