Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab2BMPIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 10:08:13 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44053 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab2BMPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 10:08:12 -0500
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <20120209150652.5b1d19dc.akpm@linux-foundation.org>
Date: Mon, 13 Feb 2012 10:08:05 -0500
Cc: Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Content-Transfer-Encoding: 7bit
Message-Id: <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com>
References: <20120207141155.GA16184@elgon.mountain> <4F323388.7040902@kernel.dk> <20120208142513.4db2493a.akpm@linux-foundation.org> <4F33BF05.208@gmail.com> <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com> <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net> <20120209150652.5b1d19dc.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here goes a quick summary.

Proposed names
==============

kaalloc        (Alexey Dobriyan)

kcallocn       (Andrew Morton)

kmalloc_array  (Pekka Enberg)

knalloc        (Andrew Morton, Xi Wang)

kncalloc       (Andrew Morton)

Other changes
=============

Documentation/CodingStyle "Chapter 14: Allocating memory"

* Mention the new array allocator whatever-it-is-called.

* Add some description:

"The preferred form for allocating an array is the following:

	p = whatever-it-is-called(n, sizeof(...), ...);

To return zeroed items, the preferred form is the following: 

	p = kcalloc(n, sizeof(...), ...);

Both forms avoid overflowing the allocation size n * sizeof(...)."

* Add some checkpatch rule?

- xi
