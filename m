Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab2LVNbu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 08:31:50 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:50256 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2LVNbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 08:31:48 -0500
Date: Sat, 22 Dec 2012 15:31:45 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-mips@linux-mips.org
Subject: Re: 3.8-rc1 build failure with MIPS/SPARSEMEM
Message-ID: <20121222133145.GC6847@blackmetal.musicnaut.iki.fi>
References: <20121222122757.GB6847@blackmetal.musicnaut.iki.fi>
 <20121222131022.GA16364@otc-wbsnb-06>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121222131022.GA16364@otc-wbsnb-06>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Dec 22, 2012 at 03:10:23PM +0200, Kirill A. Shutemov wrote:
> On Sat, Dec 22, 2012 at 02:27:57PM +0200, Aaro Koskinen wrote:
> > It looks like commit 816422ad76474fed8052b6f7b905a054d082e59a
> > (asm-generic, mm: pgtable: consolidate zero page helpers) broke
> > MIPS/SPARSEMEM build in 3.8-rc1:
> 
> Could you try this:
> 
> http://permalink.gmane.org/gmane.linux.kernel/1410981

It's not helping. And if you look at the error, it shows linux/mm.h is
already there?

[...]
In file included from /home/aaro/git/linux/arch/mips/include/asm/pgtable.h:388:0,
                 from include/linux/mm.h:44,
                 from arch/mips/kernel/asm-offsets.c:14:
[...]

A.
