Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab0INSGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:06:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703Ab0INSGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:06:12 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTim8xzipTHTCvGegkbuCoT51EZVox32xasQaq_yq@mail.gmail.com>
References: <1284483964-2370-1-git-send-email-penberg@kernel.org>
 <1284483964-2370-2-git-send-email-penberg@kernel.org> <AANLkTinxNbBQ3phKH8aoOSCO-+3FLn=te4OAqx4J8cU+@mail.gmail.com>
 <alpine.DEB.2.00.1009141227430.31857@router.home> <AANLkTim8xzipTHTCvGegkbuCoT51EZVox32xasQaq_yq@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Sep 2010 11:05:09 -0700
Message-ID: <AANLkTinhfKmxZRQNvXvtrwAp_y2Uz4PZj67m=QUr6=Va@mail.gmail.com>
Subject: Re: [PATCH 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't see this before I replied to the 1/2 patch..

On Tue, Sep 14, 2010 at 10:59 AM, Pekka Enberg <penberg@kernel.org> wrote:
> On Tue, 14 Sep 2010, Pekka Enberg wrote:
>>> Unfortunately this breaks "slabtop". I guess we could try some other delimiter?
>
> On Tue, Sep 14, 2010 at 8:28 PM, Christoph Lameter <cl@linux.com> wrote:
>> + ?
>
> Looking at procps sources, slabtop and other utilities seem to think
> slab cache names are limited to 64 bytes. Linus, are you OK with
> adding a "+" character prefix for merged caches like you suggested in
> private?

I'd much rather see "x+y+z" and actually see what the slab entries are.

But we can certainly also say "limit it to 64 bytes" and truncate
things past that.

                Linus
