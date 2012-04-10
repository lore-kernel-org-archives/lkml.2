Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022Ab2DJPCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:02:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:53372 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759000Ab2DJPCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:02:30 -0400
Date: Tue, 10 Apr 2012 17:02:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.4-rc2-rt1
In-Reply-To: <201204101458.20026.arnd@arndb.de>
Message-ID: <alpine.LFD.2.02.1204101701450.2542@ionos>
References: <alpine.LFD.2.02.1204101642050.2542@ionos> <201204101458.20026.arnd@arndb.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2012, Arnd Bergmann wrote:
> On Tuesday 10 April 2012, Thomas Gleixner wrote:
>  net/rds/ib_rdma.c       |    3 ++-
>  13 files changed, 72 insertions(+), 15 deletions(-)
> 
> is not the one you describe above but the one for the 3.2.14-rt24 release,
> right? Otherwise it would be considerably smaller compared to 3.2-rt, not
> just a bit ;-)

Someone should forbit copy and paste, really. :)

