Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab2BNQnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:43:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50092 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab2BNQnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:43:41 -0500
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <alpine.DEB.2.00.1202141032410.22250@router.home>
Date: Tue, 14 Feb 2012 11:43:36 -0500
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Content-Transfer-Encoding: 7bit
Message-Id: <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com> <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net> <20120209150652.5b1d19dc.akpm@linux-foundation.org> <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home> <20120214072017.GF26353@mwanda> <alpine.DEB.2.00.1202140858080.20013@router.home> <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com> <alpine.DEB.2.00.1202141032410.22250@router.home>
To: Christoph Lameter <cl@linux.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 14, 2012, at 11:34 AM, Christoph Lameter wrote:
> You can if you check the results later. A zero size return would be an
> indication of an error. No need to pass it on to kmalloc.

Maybe I misunderstood something here.  How do you not pass it to
kmalloc() with kmalloc(SAFE_ARRAY_SIZE(n, size), ...)?

- xi
