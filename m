Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab2GMRXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 13:23:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755936Ab2GMRXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 13:23:18 -0400
Date: Fri, 13 Jul 2012 19:20:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Denys Vlasenko <vda.linux@gmail.com>, linux-kernel@vger.kernel.org,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        "H. J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: [PATCH v2] Extend core dump note section to contain file names
	of mapped files
Message-ID: <20120713172036.GA25244@redhat.com>
References: <201207122142.02137.vda.linux@googlemail.com> <20120713145806.GA17217@redhat.com> <20120713155632.GA30239@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713155632.GA30239@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13, Andi Kleen wrote:
>
> More information during debugging is always good.

Agreed.

BTW. Can't we turn (rename and export) alloc_fdmem/free_fdmem
into the generic helpers? This patch looks like the "obvious"
user. And pidlist_allocate... probably something else.

(Denys, to avoid the confusion, I do not suggest to change your
 patch now, we can do this later).

Oleg.

