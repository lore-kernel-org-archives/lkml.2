Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab0I1U7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 16:59:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36929
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205Ab0I1U7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 16:59:54 -0400
Date: Tue, 28 Sep 2010 14:00:14 -0700 (PDT)
Message-Id: <20100928.140014.115950817.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, bharrosh@panasas.com, julia@diku.dk,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Subject: Re: {painfully BISECTED} Please revert f25c80a4b2:
 arch/um/drivers: remove duplicate structure field initialization
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTi=E7+CpJZE3XC7O1LvJu6LWfmvSxonskH4CYg25@mail.gmail.com>
References: <AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com>
	<20100928134721.f79a5955.akpm@linux-foundation.org>
	<AANLkTi=E7+CpJZE3XC7O1LvJu6LWfmvSxonskH4CYg25@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Sep 2010 13:57:04 -0700

> So perhaps something like the attached patch would make it work, and
> have the locking in place that apparently people think it should have?

I'm fine with this if it works:

Acked-by: David S. Miller <davem@davemloft.net>
