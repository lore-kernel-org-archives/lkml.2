Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592Ab2JLCaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 22:30:23 -0400
Received: from ozlabs.org ([203.10.76.45]:60900 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759576Ab2JLCaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 22:30:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexander Duyck <alexander.h.duyck@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: Re: [PATCH v2 8/8] x86/lguest: Use __pa_symbol instead of __pa on C visible symbols
In-Reply-To: <20121011205035.12787.84083.stgit@gitlad.jf.intel.com>
References: <20121011204324.12787.30514.stgit@gitlad.jf.intel.com> <20121011205035.12787.84083.stgit@gitlad.jf.intel.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 12 Oct 2012 09:17:33 +1030
Message-ID: <87obk862yi.fsf@rustcorp.com.au>
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

Thanks,
Rusty.
