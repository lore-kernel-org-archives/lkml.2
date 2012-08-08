Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351Ab2HHNuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:50:32 -0400
Received: from mail.x86-64.org ([217.9.48.20]:41547 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440Ab2HHNub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:50:31 -0400
Date: Wed, 8 Aug 2012 15:50:27 +0200
From: Borislav Petkov <bp@amd64.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: WARNING: at mm/page_alloc.c:4514 free_area_init_node+0x4f/0x37b()
Message-ID: <20120808135027.GD16636@aftab.osrc.amd.com>
References: <20120801173837.GI8082@aftab.osrc.amd.com>
 <20120801233335.GA4673@barrios>
 <20120802110641.GA16328@aftab.osrc.amd.com>
 <20120806000157.GA10971@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120806000157.GA10971@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 09:01:57AM +0900, Minchan Kim wrote:
> Linus already applied the patch in rc-1 but he might need better changelog.
> I am not sure I send this patch to whom, Linus or Andrew?
> Anyway, Please use below if really need it.

Btw, I see Linus has already shut up the warning upstream:

commit 8783b6e2b2cb726f2734cf208d101f73ac1ba616
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Aug 2 10:37:03 2012 -0700

    mm: remove node_start_pfn checking in new WARN_ON for now
...

So I guess all is well.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
