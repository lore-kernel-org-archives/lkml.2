Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505Ab2IEVNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:13:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:52835 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab2IEVNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:13:36 -0400
Message-ID: <1346879598.19098.4.camel@pasglop>
Subject: Re: [PATCH v2] powerpc: fix personality handling in
 ppc64_personality()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Sep 2012 07:13:18 +1000
In-Reply-To: <alpine.LNX.2.00.1209051056060.11079@pobox.suse.cz>
References: <alpine.LNX.2.00.1208012201520.14910@pobox.suse.cz>
	 <m27gtitfv4.fsf@igel.home>
	 <alpine.LNX.2.00.1208020907490.14910@pobox.suse.cz>
	 <1346813643.2257.24.camel@pasglop>
	 <alpine.LNX.2.00.1209051056060.11079@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 10:56 +0200, Jiri Kosina wrote:

> Hi Benjamin,
> 
> actually commit 7256a5d2da56 seems to contain the correct PER_LINUX 
> handling, so seems like you picked the right one :)
> 

Odd, they looked different around the use of PER_MASK when I looked but
I was tired & jet lagged, so I might have just had a brain fail...

Cheers,
Ben.


