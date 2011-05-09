Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1EITwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:52:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60557
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480Ab1EITwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:52:19 -0400
Date: Mon, 09 May 2011 12:51:46 -0700 (PDT)
Message-Id: <20110509.125146.229755454.davem@davemloft.net>
To: joe@perches.com
Cc: grundler@parisc-linux.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] tulip: xircom_cb: Convert #ifdef DEBUG
 blocks and enter/leave uses
From: David Miller <davem@davemloft.net>
In-Reply-To: <abc11d127dbde89baf98eaa6c409d89b2a8a5a21.1304970062.git.joe@perches.com>
References: <cover.1304970062.git.joe@perches.com>
	<abc11d127dbde89baf98eaa6c409d89b2a8a5a21.1304970062.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon,  9 May 2011 12:45:20 -0700

> Change the blocks that are guarded by #if DEBUG to
> be #if defined DEBUG && DEBUG > 1 so that pr_debug
> can be used later.
> 
> Remove enter/leave macros and uses.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
