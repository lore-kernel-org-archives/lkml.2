Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1EYTGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:06:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:48343 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab1EYTGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:06:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,268,1304319600"; 
   d="scan'208";a="8694330"
Date: Wed, 25 May 2011 12:05:23 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525190523.GA14151@tassilo.jf.intel.com>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <20110525070604.GE429@elte.hu>
 <20110525160656.GB25225@khazad-dum.debian.net>
 <20110525165803.GB14958@tassilo.jf.intel.com>
 <20110525182405.GA17864@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525182405.GA17864@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I hadn't really expected this simple patchkit to generate
that much email :-) 

> Many years ago i had an old P3 system where i mixed steppings and it 
> was not stable, it would crash after i have put some load on the 
> system.

Ok.

But it's not clear to me how to reliably do it for the microcode
at boot.  Because a future microcode update could fix it up, but the kernel
can't know if there will be a microcode update or not.
So I don't think it can be done at boot at least.

If you want me to rewrite the microcode update driver or something
like that that's outside the scope of my patchkit, sorry.

-Andi
