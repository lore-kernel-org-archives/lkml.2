Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3AHPda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 10:33:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756646Ab3AHPd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 10:33:28 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, zab@redhat.com,
        bcrl@kvack.org, viro@zeniv.linux.org.uk, tytso@mit.edu
Subject: Re: [PATCH 29/32] block, aio: Batch completion for bios/kiocbs
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
	<1356573611-18590-32-git-send-email-koverstreet@google.com>
	<50E69F5B.8060902@kernel.dk> <20130107233443.GG26407@google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 08 Jan 2013 10:33:18 -0500
In-Reply-To: <20130107233443.GG26407@google.com> (Kent Overstreet's message of
	"Mon, 7 Jan 2013 15:34:43 -0800")
Message-ID: <x49r4lvadvl.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:

>> Is the rbtree really faster than a basic (l)list and a sort before
>> completing them? Would be simpler.
>
> Well, depends. With one or two kioctxs? The list would definitely be
> faster, but I'm loathe to use an O(n^2) algorithm anywhere where the
> input size isn't strictly controlled, and I know of applications out
> there that use tons of kioctxs.

Out of curiosity, what applications do you know of that use tons of
kioctx's?

-Jeff
