Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2I2KfX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 06:35:23 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:33652 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab2I2KfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 06:35:22 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: ARM SoC tree, Was: Re: [PATCH 05/12] ARM: ixp4xx: use __iomem for MMIO
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
	<1348868177-21205-6-git-send-email-arnd@arndb.de>
Date: Sat, 29 Sep 2012 12:35:17 +0200
In-Reply-To: <1348868177-21205-6-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Fri, 28 Sep 2012 23:36:10 +0200")
Message-ID: <m3lift6rru.fsf_-_@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> Krzysztof, please apply in your next branch so this problem goes away in
> 3.8.

Right, I'll look at it.

> I realize it won't make 3.7 any more since the base patches are not
> in arm-soc, but it's bad if linux-next is broken.

Well, I'm not aware of any requirement to push my IXP4xx changes
exclusively through arm-soc. I believe I can still send my tree straight
to Linus.

My tree is fairly isolated (with one trivial patch in need of ack from
Russell, but I can remove that) and, to be honest, I can't see any
benefit to anyone, caused by sending through intermediate trees. In
fact, now that I have at last a bit of spare time to work on IXP4xx
again (acquired some IXP435 devices), such requirement would only mean
extra workload to me.

Could you please point me to a statement requiring eg. my changes to go
through arm-soc?

Thanks.
-- 
Krzysztof Halasa
