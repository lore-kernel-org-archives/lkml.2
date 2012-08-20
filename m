Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab2HTJdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:33:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52464 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab2HTJdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:33:39 -0400
Date: Mon, 20 Aug 2012 02:33:38 -0700 (PDT)
Message-Id: <20120820.023338.1391780882497223636.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix error return code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1345189618-13758-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345189618-13758-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Fri, 17 Aug 2012 09:46:55 +0200

> These patches fix cases where the return code appears to be unintentially
> nonnegative.

All applied, thanks Julia.
