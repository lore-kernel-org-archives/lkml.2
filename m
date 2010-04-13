Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab0DMFIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 01:08:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54412
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882Ab0DMFIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 01:08:34 -0400
Date: Mon, 12 Apr 2010 22:08:38 -0700 (PDT)
Message-Id: <20100412.220838.132238558.davem@davemloft.net>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH 0/4]: Respin local_irq_*_nmi() stuff.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100409.160132.216116766.davem@davemloft.net>
References: <20100409.160132.216116766.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm rescinding these patches for now, for two reasons:

1) The NMI annotations necessary to get everything working really gets
   out of control.

2) I think I found a cheap way to do this in sparc64 specific code.

Thanks!
