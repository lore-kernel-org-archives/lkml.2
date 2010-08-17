Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab0HQRvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:51:17 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:45666 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754819Ab0HQRvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:51:14 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 5kvlEfgVM1nMnY8FxaVZdT1ee.AML.gUTDx2gA.mu9.oQAG
 xXjtjkLHVad8j2KDLGQTJRW.0VpEz8x79FG09Z5hsYxbAg.ZbDuk9AcZBGeT
 cZFKqqSxI15MM7laJ3KHVwPHVV5XPvklESKEtzeynB8JH07Yl1wpxG5ArrAk
 s2Trfurgtnin.hxLlv_1f5utYlXxLgRyOQfHE1WGBgFgAhPqD99FrmkID1XA
 -
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 17 Aug 2010 12:51:09 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q3 20/23] slub: Shared cache to exploit cross cpu caching
 abilities.
In-Reply-To: <alpine.DEB.2.00.1008162246500.26781@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008171234130.12188@router.home>
References: <20100804024514.139976032@linux.com> <20100804024535.338543724@linux.com> <alpine.DEB.2.00.1008162246500.26781@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Aug 2010, David Rientjes wrote:

> This explodes on the memset() in slab_alloc() because of __GFP_ZERO on my
> system:

Well that seems to be because __kmalloc_node returned invalid address. Run
with full debugging please?

