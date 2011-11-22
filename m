Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab1KVWbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:31:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43253 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab1KVWbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:31:16 -0500
Message-ID: <1322001070.19663.17.camel@edumazet-laptop>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christian Kujau <lists@nerdbynature.de>, Christoph Lameter <cl@linux.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Date: Tue, 22 Nov 2011 23:31:10 +0100
In-Reply-To: <1322000195.14573.13.camel@pasglop>
References: <20111121131531.GA1679@x4.trippels.de>
	 <1321884966.10470.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20111121153621.GA1678@x4.trippels.de>
	 <1321890510.10470.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20111121161036.GA1679@x4.trippels.de>
	 <1321894353.10470.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1321895706.10470.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20111121173556.GA1673@x4.trippels.de>
	 <1321900743.10470.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20111121185215.GA1673@x4.trippels.de>
	 <20111121195113.GA1678@x4.trippels.de> <1321907275.13860.12.camel@pasglop>
	 <alpine.DEB.2.01.1111211617220.8000@trent.utfs.org>
	 <alpine.DEB.2.00.1111212105330.19606@router.home>
	 <1321948113.27077.24.camel@edumazet-laptop>
	 <alpine.DEB.2.01.1111220038060.8000@trent.utfs.org>
	 <1322000195.14573.13.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 23 novembre 2011 à 09:16 +1100, Benjamin Herrenschmidt a
écrit :

> Yes, please try the patch with SLUB and let us know if it makes a
> difference.
> 
> Eric, Christoph, the generic version of this_cpu_cmpxchg() is not
> interrupt safe, so I suppose this patch should go in right ?
> 

Sure. Dont worry, Christoph is the slub maintainer :)




