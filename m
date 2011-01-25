Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab1AYFFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 00:05:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47427
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354Ab1AYFFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 00:05:08 -0500
Date: Mon, 24 Jan 2011 21:05:43 -0800 (PST)
Message-Id: <20110124.210543.193717502.davem@davemloft.net>
To: eugeneteo@kernel.org
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        bhutchings@solarflare.com
Subject: Re: net: clear heap allocation for ethtool_get_regs()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110125044910.GB8117@infradead.org>
References: <20110125044910.GB8117@infradead.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eugene Teo <eugeneteo@kernel.org>
Date: Tue, 25 Jan 2011 12:49:10 +0800

> There is a conflict between commit b00916b1 and a77f5db3. This patch resolves
> the conflict by clearing the heap allocation in ethtool_get_regs().
> 
> Cc: stable@kernel.org
> Signed-off-by: Eugene Teo <eugeneteo@kernel.org>

Applied, thanks Eugene.
