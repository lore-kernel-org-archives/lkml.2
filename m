Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0HQPAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:00:44 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:38121 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab0HQPAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:00:42 -0400
Date: Tue, 17 Aug 2010 16:00:35 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: David Daney <david.s.daney@gmail.com>, linux-kernel@vger.kernel.org,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org
Subject: Re: [PATCH] MIPS: remove RELOC_HIDE on __pa_symbol
Message-ID: <20100817150035.GC17861@linux-mips.org>
References: <1281297456-2711-1-git-send-email-namhyung@gmail.com>
 <4C5F8ED8.90301@gmail.com>
 <20100809122147.GA23053@linux-mips.org>
 <1281409628.1670.11.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281409628.1670.11.camel@leonhard>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 12:07:08PM +0900, Namhyung Kim wrote:

> I've sent basically same patch to x86 folks [1] and they said there is a
> possiblility of miscompilation on gcc 3. I am not sure the same goes
> here on mips but it might be safer to keep it. Sorry for the noise ;-(
> 
> [1] http://lkml.org/lkml/2010/8/8/138

So in a distant future when GCC 3.x will finally be retired we will be
able to apply this patch, sigh.  I'll drop your patch for the time being
and add a comment to the code.

Thanks!

  Ralf
