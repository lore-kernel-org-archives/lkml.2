Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab1KUI4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 03:56:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57265 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab1KUI4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 03:56:42 -0500
Message-ID: <1321865797.2552.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 21 Nov 2011 09:56:37 +0100
In-Reply-To: <20111121082445.GD1625@x4.trippels.de>
References: <20111118072519.GA1615@x4.trippels.de>
	 <20111118075521.GB1615@x4.trippels.de> <1321605837.30341.551.camel@debian>
	 <20111118085436.GC1615@x4.trippels.de>
	 <20111118120201.GA1642@x4.trippels.de> <1321836285.30341.554.camel@debian>
	 <20111121080554.GB1625@x4.trippels.de>
	 <20111121082445.GD1625@x4.trippels.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 21 novembre 2011 à 09:24 +0100, Markus Trippelsdorf a écrit :

> So everything points to commit 87fb4b7b533:
> "net: more accurate skb truesize"
> 
> Can you take a look Eric?
> 

Sure I can, right now.

I'll send an update ASAP

Thanks


