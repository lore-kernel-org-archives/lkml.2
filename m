Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab2KPGk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:40:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51876 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2KPGk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:40:57 -0500
Date: Fri, 16 Nov 2012 01:40:56 -0500 (EST)
Message-Id: <20121116.014056.1166943441654050720.davem@davemloft.net>
To: simon.marchi@polymtl.ca
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, cmetcalf@tilera.com
Subject: Re: [PATCH] tilegx: request_irq with a non-null device name
From: David Miller <davem@davemloft.net>
In-Reply-To: <1353039199-12520-1-git-send-email-simon.marchi@polymtl.ca>
References: <1353039199-12520-1-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Marchi <simon.marchi@polymtl.ca>
Date: Thu, 15 Nov 2012 23:13:19 -0500

> This patch simply makes the tilegx net driver call request_irq with a
> non-null name. It makes the output in /proc/interrupts more obvious, but
> also helps tools that don't expect to find null there.
> 
> Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>

Applied, thanks.
