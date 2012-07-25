Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab2GYWtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 18:49:02 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46737 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab2GYWs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 18:48:59 -0400
Date: Wed, 25 Jul 2012 15:48:58 -0700 (PDT)
Message-Id: <20120725.154858.2001228990733826265.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,1/2] hyperv: Add a check for ring_size value
From: David Miller <davem@davemloft.net>
In-Reply-To: <1343239722-21328-1-git-send-email-haiyangz@microsoft.com>
References: <1343239722-21328-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Wed, 25 Jul 2012 11:08:41 -0700

> It prevents ring_size being set to a too small value.
> 
> Reported-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied.
