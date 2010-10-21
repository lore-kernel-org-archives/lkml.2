Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab0JUL3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 07:29:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43489
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757559Ab0JUL3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 07:29:36 -0400
Date: Thu, 21 Oct 2010 04:29:59 -0700 (PDT)
Message-Id: <20101021.042959.91336397.davem@davemloft.net>
To: jan.kiszka@web.de
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
        netdev@vger.kernel.org, isdn@linux-pingi.de, peterz@infradead.org
Subject: Re: [PATCH v2] CAPI: Silence lockdep warning on
 get_capi_appl_by_nr usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CBB13B7.8080705@web.de>
References: <4CB9891B.4060606@web.de>
	<1287311135.1998.154.camel@laptop>
	<4CBB13B7.8080705@web.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@web.de>
Date: Sun, 17 Oct 2010 17:18:15 +0200

> As long as we hold capi_controller_lock, we can safely access
> capi_applications without RCU protection as no one can modify the
> application list underneath us. Introduce an RCU-free
> __get_capi_appl_by_nr for this purpose. This silences lockdep warnings
> on suspicious rcu_dereference usage.
> 
> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

Applied.
