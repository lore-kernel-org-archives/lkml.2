Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934894Ab1KJPHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:07:01 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:21621 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934229Ab1KJPHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:07:00 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Nov 2011 10:06:59 EST
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: iw1zU6wVM1k_7ypt4wiMt4fZacEoyZVpCDsOW1oVp4SDvkv
 _QZPafjEGJnA0JSI82gGRzjw2HZrGcUbkgkRJ6eCSG0mY2C9lceJLUV.QtCZ
 qn08AJoFgUpqelcNstfWRWC.zCa_PWAd5aNX2DZpgjBefE7o11awBfWhmEF5
 p8AKscU8MG1l7ennJMnCD9ldwTA1vegckS.ooRCPVjAfCB9MEUGIqLI7ZE5X
 hGaK1vg6BhAnkUyWk.tOAor9KE9a8plKOhoa17VOqVIW2r.zdlABJFdEvEIP
 N6srtvaj0pgAVBQvoyoefmYBKkgl7I7KLyWDBN1akiTw62dahY2U42zcgeST
 7QRoGvmcRgzvRZzIn2CnvtWTOOrv_EkfUKTYpxgT_oH5vKA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 10 Nov 2011 09:00:16 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Dike <jdike@addtoit.com>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm,slub,x86: decouple size of struct page from
 CONFIG_CMPXCHG_LOCAL
In-Reply-To: <1320933860-15588-2-git-send-email-heiko.carstens@de.ibm.com>
Message-ID: <alpine.DEB.2.00.1111100900010.19196@router.home>
References: <1320933860-15588-1-git-send-email-heiko.carstens@de.ibm.com> <1320933860-15588-2-git-send-email-heiko.carstens@de.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Nov 2011, Heiko Carstens wrote:

> If an architecture supports CMPXCHG_LOCAL this shouldn't result automatically
> in larger struct pages if the SLUB allocator is used. Instead introduce a new
> config option "HAVE_ALIGNED_STRUCT_PAGE" which can be selected if a double
> word aligned struct page is required.
> Also update x86 Kconfig so that it should work as before.

Acked-by: Christoph Lameter <cl@linux.com>
