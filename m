Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab1KUOVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:21:09 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:51109 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1KUOVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:21:04 -0500
Date: Mon, 21 Nov 2011 15:21:02 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
Message-ID: <20111121142102.GA1676@x4.trippels.de>
References: <20111118075521.GB1615@x4.trippels.de>
 <1321605837.30341.551.camel@debian>
 <20111118085436.GC1615@x4.trippels.de>
 <20111118120201.GA1642@x4.trippels.de>
 <1321836285.30341.554.camel@debian>
 <20111121080554.GB1625@x4.trippels.de>
 <20111121082445.GD1625@x4.trippels.de>
 <1321866988.2552.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20111121131531.GA1679@x4.trippels.de>
 <1321884966.10470.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1321884966.10470.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.11.21 at 15:16 +0100, Eric Dumazet wrote:
> Le lundi 21 novembre 2011 à 14:15 +0100, Markus Trippelsdorf a écrit :
> 
> > I've enabled CONFIG_SLUB_DEBUG_ON and this is what happend:
> > 
> 
> Thanks
> 
> Please continue to provide more samples.
> 
> There is something wrong somewhere, but where exactly, its hard to say.
> 
> Something is keeping a pointer to freed memory and reuse it while memory
> had been reused.
> 
> Are you using hugepages ?

Only CONFIG_TRANSPARENT_HUGEPAGE and CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS.

I've increased LOG_BUF_SHIFT to 18, because it looks like the beginning
of the SLUB_DEBUG output was cut off last time.

-- 
Markus
