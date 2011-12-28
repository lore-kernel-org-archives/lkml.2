Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab1L1JoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 04:44:04 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63561 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1L1JoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 04:44:03 -0500
Date: Wed, 28 Dec 2011 13:43:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111228094356.GE27266@moon>
References: <20111223124741.711871189@openvz.org>
 <20111223124920.661126615@openvz.org>
 <20111227152344.c8c140d3.akpm@linux-foundation.org>
 <20111228074214.GC27266@moon>
 <20111228014250.51c2e60e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228014250.51c2e60e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 01:42:50AM -0800, Andrew Morton wrote:
> On Wed, 28 Dec 2011 11:42:14 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > Maybe we could simply extend prctl then?
> 
> I'd suggest a syscall.  prctl is a big crap bucket and this thing has
> simple, well defined semantics.  syscalls are cheap.
> 

OK. I'll think about it. Thanks!

	Cyrill
