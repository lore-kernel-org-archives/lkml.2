Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab2EJLb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 07:31:26 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60637 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894Ab2EJLbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 07:31:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205090907070.8171@router.home>
References: <CAFLxGvy0PHZHVL9rZx_0oFGobKftPBc0EN3VEyzNqvg13FUEfw@mail.gmail.com>
	<alpine.DEB.2.00.1205090907070.8171@router.home>
Date: Thu, 10 May 2012 13:31:24 +0200
Message-ID: <CAFLxGvymF0yo3k_j6EON-nk9=mQDaL72mnBxxJOv2awiWgjeYQ@mail.gmail.com>
Subject: Re: BUG at mm/slub.c:374
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 4:14 PM, Christoph Lameter <cl@linux.com> wrote:
> On Wed, 9 May 2012, richard -rw- weinberger wrote:
>
>> A few minutes ago I saw this BUG within one of my KVM machines.
>> Config is attached.
>
> Interrupts on in __cmpxchg_double_slab called from __slab_alloc? Does KVM
> do some tricks with interrupt flags? I do not see how that can be
> otherwise since __slab_alloc disables interrupts on entry and reenables on
> exit.

Dunno.
So far I've seen this BUG only once. :-\

-- 
Thanks,
//richard
