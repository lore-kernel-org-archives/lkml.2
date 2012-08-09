Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab2HINQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:16:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab2HINQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:16:10 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: Re: [PATCH] bio: Fix potential memory leak in bio_find_or_create_slab()
References: <1344491532-4969-1-git-send-email-khoroshilov@ispras.ru>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 09 Aug 2012 09:15:10 -0400
In-Reply-To: <1344491532-4969-1-git-send-email-khoroshilov@ispras.ru> (Alexey
	Khoroshilov's message of "Thu, 9 Aug 2012 09:52:12 +0400")
Message-ID: <x49393ww6jl.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Khoroshilov <khoroshilov@ispras.ru> writes:

> Do not leak memory by updating pointer with potentially NULL realloc return value.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Jeff Moyer <jmoyer@redhat.com>
