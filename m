Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1GLQGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:06:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43185 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1GLQGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:06:33 -0400
Subject: Re: [slubllv7 06/17] slub: Add cmpxchg_double_slab()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.DEB.2.00.1107121057550.2931@router.home>
References: <20110601172543.437240675@linux.com>
	 <20110601172615.286693377@linux.com>
	 <1310414100.2860.6.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1107121057550.2931@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 18:06:21 +0200
Message-ID: <1310486781.2871.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 12 juillet 2011 à 10:59 -0500, Christoph Lameter a écrit :

> We do not need to have _count included. This is just there because the
> field is in the way on 64 bit and we can only do 2x 64 bit cmpxchges.  On
> 32 bi we can drop _count from "counters".
> 

OK, thanks for clarification.


