Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab2JISfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:35:40 -0400
Received: from mail.x86-64.org ([217.9.48.20]:39907 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab2JISfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:35:38 -0400
Date: Tue, 9 Oct 2012 20:35:23 +0200
From: Borislav Petkov <bp@amd64.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Handln new rbtree implementation
Message-ID: <20121009183523.GA30242@aftab.osrc.amd.com>
References: <20121009170734.GB32508@aftab.osrc.amd.com>
 <20121009180156.GA245@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009180156.GA245@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 08:01:56PM +0200, Markus Trippelsdorf wrote:
> Perf build fails with the new rbtree implementation:
> 
> ../../lib/rbtree.c:24:36: fatal error: linux/rbtree_augmented.h: No such
> file or
> directory                                                                                      
> compilation terminated.                                                  
> make[2]: *** [util/rbtree.o] Error 1                                    
> make[1]: *** [perf_install] Error 2                                     
> make: *** [tools/perf_install] Error 2
> 
> Fix by updating the Makefile and adding a btree_augmented.h wrapper.
> 
> Reported-by: Borislav Petkov <borislav.petkov@amd.com>
> Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>

Good job!

Tested-by: Borislav Petkov <borislav.petkov@amd.com>

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
