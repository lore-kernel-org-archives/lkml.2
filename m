Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab2JVTRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:17:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32894 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab2JVTRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:17:35 -0400
Date: Mon, 22 Oct 2012 15:17:24 -0400 (EDT)
Message-Id: <20121022.151724.1162375667344795177.davem@davemloft.net>
To: joe.jin@oracle.com
Cc: jitendra.kalsaria@qlogic.com, ron.mercer@qlogic.com,
        Linux-Driver@qlogic.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        greg.marsden@oracle.com
Subject: Re: [PATCH] qla3xxx: Ensure request/response queue addr writes to
 the registers
From: David Miller <davem@davemloft.net>
In-Reply-To: <50849604.9050109@oracle.com>
References: <50849604.9050109@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Jin <joe.jin@oracle.com>
Date: Mon, 22 Oct 2012 08:40:36 +0800

> Before use the request and response queue addr, make sure it has wrote
> to the registers.
> 
> Signed-off-by: Joe Jin <joe.jin@oracle.com>

Applied.
