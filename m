Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1D0GHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:07:20 -0400
Received: from ozlabs.org ([203.10.76.45]:48992 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab1D0GHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:07:14 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anders Kaseorg <andersk@ksplice.com>, Michal Marek <mmarek@suse.cz>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] modpost: Update 64k section support for binutils 2.18.50
In-Reply-To: <alpine.DEB.2.02.1104251122320.26664@dr-wily.mit.edu>
References: <alpine.DEB.2.02.1104251122320.26664@dr-wily.mit.edu>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Wed, 27 Apr 2011 15:02:41 +0930
Message-ID: <877hagl0na.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011 11:30:13 -0400 (EDT), Anders Kaseorg <andersk@ksplice.com> wrote:
> Binutils 2.18.50 made a backwards-incompatible change in the way it
> writes ELF objects with over 65280 sections, to improve conformance
> with the ELF specification and interoperability with other ELF tools.
> Specifically, it no longer adds 256 to section indices SHN_LORESERVE
> and higher to skip over the reserved range SHN_LORESERVE through
> SHN_HIRESERVE; those values are only considered special in the
> st_shndx field, and not in other places where section indices are
> stored.  See:
> 
> http://sourceware.org/bugzilla/show_bug.cgi?id=5900
> http://groups.google.com/group/generic-abi/browse_thread/thread/e8bb63714b072e67/6c63738f12cc8a17

Applied.

Thanks,
Rusty.
