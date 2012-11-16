Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab2KPT0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:26:32 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57589 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2KPT03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:26:29 -0500
Date: Fri, 16 Nov 2012 11:26:27 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: convert update_mmu_cache() and update_mmu_cache_pmd()
 to functions
In-Reply-To: <1353059717-9850-2-git-send-email-kirill.shutemov@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1211161122070.2788@chino.kir.corp.google.com>
References: <1353059717-9850-1-git-send-email-kirill.shutemov@linux.intel.com> <1353059717-9850-2-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012, Kirill A. Shutemov wrote:

> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> Converting macros to functions unhide type problems before changes will
> be integrated and trigger problems on other architectures.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

[routing to x86 maintainers]

Acked-by: David Rientjes <rientjes@google.com>

Do you want to fix arch/s390/include/asm/pgtable.h in the same way in a 
separate patch and send it to Martin Schwidefsky <schwidefsky@de.ibm.com> 
and Heiko Carstens <heiko.carstens@de.ibm.com>?
