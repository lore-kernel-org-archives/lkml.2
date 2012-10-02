Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2JBQhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:37:43 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:33178 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab2JBQhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:35 -0400
X-IronPort-AV: E=Sophos;i="4.80,524,1344211200"; 
   d="scan'208";a="14899673"
Date: Tue, 2 Oct 2012 17:36:34 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: make dtbs in linus/master
Message-ID: <alpine.DEB.2.02.1210021725320.29232@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I am testing linus/master after the recent merge with the arm-soc tree
and I find that if I choose:

ARM system type
  1. Allow multiple platforms to be selected (ARCH_MULTIPLATFORM) (NEW)
  2. ARM Ltd. Integrator family (ARCH_INTEGRATOR)
  3. ARM Ltd. RealView family (ARCH_REALVIEW)
>  4. ARM Ltd. Versatile family (ARCH_VERSATILE)

in my kernel config, then "make dtbs" doesn't work.
However if I choose ARCH_MULTIPLATFORM then it works properly.

Is it expected?

Cheers,

Stefano
