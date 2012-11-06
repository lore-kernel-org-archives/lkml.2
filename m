Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663Ab2KFCKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 21:10:43 -0500
Received: from ozlabs.org ([203.10.76.45]:45865 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933490Ab2KFCKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 21:10:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexander Duyck <alexander.h.duyck@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: Re: [PATCH v3 8/8] x86/lguest: Use __pa_symbol instead of __pa on C visible symbols
In-Reply-To: <20121105190618.10205.95341.stgit@gitlad.jf.intel.com>
References: <20121105185657.10205.27419.stgit@gitlad.jf.intel.com> <20121105190618.10205.95341.stgit@gitlad.jf.intel.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 06 Nov 2012 11:41:35 +1030
Message-ID: <87d2zr5yd4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Duyck <alexander.h.duyck@intel.com> writes:
> The function lguest_write_cr3 is using __pa to convert swapper_pg_dir and
> initial_page_table from virtual addresses to physical.  The correct function
> to use for these values is __pa_symbol since they are C visible symbols.
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.
