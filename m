Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab0I1Uvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 16:51:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56311
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786Ab0I1Uvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 16:51:32 -0400
Date: Tue, 28 Sep 2010 13:51:52 -0700 (PDT)
Message-Id: <20100928.135152.183065441.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, bharrosh@panasas.com, julia@diku.dk,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Subject: Re: {painfully BISECTED} Please revert f25c80a4b2:
 arch/um/drivers: remove duplicate structure field initialization
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100928134721.f79a5955.akpm@linux-foundation.org>
References: <4CA09977.80506@panasas.com>
	<AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com>
	<20100928134721.f79a5955.akpm@linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 28 Sep 2010 13:47:21 -0700

> Yeah, please revert it.

I'll take care of this, thanks everyone.
