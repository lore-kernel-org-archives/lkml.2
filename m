Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1CYN4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:56:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab1CYN4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:56:48 -0400
Date: Fri, 25 Mar 2011 09:56:09 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Juan J. Garcia de Soria" <skandalfo@gmail.com>
Subject: Re: linux-next: build failure after merge of the Linus' tree
Message-ID: <20110325135609.GB28606@redhat.com>
References: <20110325123535.f980dfe8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325123535.f980dfe8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 12:35:35PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> In Linus' tree, today's linux-next build (x86_64 allmodconfig) failed
> like this:
> 
> drivers/media/rc/ite-cir.c: In function 'ite_decode_bytes':
> drivers/media/rc/ite-cir.c:190: error: implicit declaration of function 'generic_find_next_le_bit'
> drivers/media/rc/ite-cir.c:199: error: implicit declaration of function 'generic_find_next_zero_le_bit'
> 
> Caused by commit 620a32bba4a2 ("[media] rc: New rc-based ite-cir driver
> for several ITE CIRs") interacting with commit c4945b9ed472
> ("asm-generic: rename generic little-endian bitops functions").
> 
> I applied the patch below for today.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 25 Mar 2011 12:30:05 +1100
> Subject: [PATCH] [media] rc: update for bitop name changes

Thanks Stephen, obviously the correct thing to do here.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

