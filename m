Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab1GTPgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 11:36:08 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:24148 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751705Ab1GTPgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 11:36:06 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: aOic63MVM1lRLzY5WrKhSpAFNp_hzs1nw7MIBOt_6axYRvB
 _.Ffk6_hN6WcUC2yYZP7.zKKMgt37X5omqf89UwK.kgdlkVmuBJqTehhEysi
 Hc5LcycFV949u26nQRhi7AbYti9xxk2.B9eApk3s6jio13AAdFrVDqMZFfUJ
 j43e_iyOrHjeXYjHkB8JW_igKNmUYk6x6CuSq31AIHA75re2uKnjsElqQtNr
 fmHOzpmLqt4xNfj6uPPgnzH.vBJ71aHtubLmpVKpWK3DTUQjxh0crH.TXhkG
 csN4GxoVd.takMZdfjE2Hmg715H1xJURVz.07iE.X6zsjObDG
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 20 Jul 2011 10:36:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Konstantin Khlebnikov <khlebnikov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>, "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
In-Reply-To: <alpine.DEB.2.00.1107201653080.4921@tiger>
Message-ID: <alpine.DEB.2.00.1107201035360.1472@router.home>
References: <20110720121612.28888.38970.stgit@localhost6> <alpine.DEB.2.00.1107201611010.3528@tiger> <4E26D7EA.3000902@parallels.com> <alpine.DEB.2.00.1107201638520.4921@tiger> <4E26DD25.4010707@parallels.com> <alpine.DEB.2.00.1107201653080.4921@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011, Pekka Enberg wrote:

> That's somewhat sad. I suppose I can just merge your patch unless other people
> object to it. I'd like a v2 with better changelog though.

Seems to be the simplest solution. Fix the changelog then add

Acked-by: Christoph Lameter <cl@linux.com>

