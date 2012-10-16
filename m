Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2JPAqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:46:07 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:47649 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab2JPAqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:46:05 -0400
Date: Mon, 15 Oct 2012 17:46:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ezequiel Garcia <elezegarcia@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Tim Bird <tim.bird@am.sony.com>,
        celinux-dev@lists.celinuxforum.org
Subject: Re: [Q] Default SLAB allocator
In-Reply-To: <CALF0-+Xp_P_NjZpifzDSWxz=aBzy_fwaTB3poGLEJA8yBPQb_Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1210151745400.31712@chino.kir.corp.google.com>
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com> <m27gqwtyu9.fsf@firstfloor.org> <alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com> <m2391ktxjj.fsf@firstfloor.org> <CALF0-+WLZWtwYY4taYW9D7j-abCJeY90JzcTQ2hGK64ftWsdxw@mail.gmail.com>
 <alpine.DEB.2.00.1210130252030.7462@chino.kir.corp.google.com> <CALF0-+Xp_P_NjZpifzDSWxz=aBzy_fwaTB3poGLEJA8yBPQb_Q@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2012, Ezequiel Garcia wrote:

> But SLAB suffers from a lot more internal fragmentation than SLUB,
> which I guess is a known fact. So memory-constrained devices
> would waste more memory by using SLAB.

Even with slub's per-cpu partial lists?
