Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab2BIN0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 08:26:32 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55186 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab2BIN0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 08:26:31 -0500
Subject: Re: [PATCH RFC] slab: introduce knalloc/kxnalloc
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <4F33C7D7.1060801@kernel.dk>
Date: Thu, 9 Feb 2012 08:26:26 -0500
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Content-Transfer-Encoding: 7bit
Message-Id: <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com>
References: <20120207141155.GA16184@elgon.mountain> <4F323388.7040902@kernel.dk> <20120208142513.4db2493a.akpm@linux-foundation.org> <4F33BF05.208@gmail.com> <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 9, 2012, at 8:19 AM, Jens Axboe wrote:
> Agree, lets not overdesign. kmalloc_array() sounds good to me, fwiw.

I like kmalloc_array.  "knalloc" can be easily confused with kmalloc.

- xi
