Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab2GFR5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:57:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757859Ab2GFR5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:57:35 -0400
Subject: Re: [PATCH] CONFIG_CC_STACKPROTECTOR is no longer experimental
From: Jean Delvare <jdelvare@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <4FF71F1C.4040608@xenotime.net>
References: <1341583705.4655.18.camel@amber.site>
	 <4FF71F1C.4040608@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Fri, 06 Jul 2012 19:57:19 +0200
Message-ID: <1341597439.4655.23.camel@amber.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

Le vendredi 06 juillet 2012 à 10:23 -0700, Randy Dunlap a écrit :
> On 07/06/2012 07:08 AM, Jean Delvare wrote:
> 
> > This feature has been around for over 5 years now, so I presume it is
> > no longer considered experimental.
> > 
> > Signed-off-by: Jean Delvare <jdelvare@suse.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Arjan van de Ven <arjan@linux.intel.com>
> > Cc: Andi Kleen <andi@firstfloor.org>
> > ---
> > Or is there any reason to still consider this an experimental feature?
> 
> 
> I doubt it, but if it is still experimental, it should also have
> 	depends on EXPERIMENTAL

Agreed.

> and then it would be nice if kconfig (the software) would add the
>   " (EXPERIMENTAL)" tag when it sees such a dependency.

Oh yeah, I've been dreaming of this for years now but never found the
time to actually look into implementing it. Not sure if I would actually
be able to anyway, as it will probably require some Kconfig magic beyond
my knowledge.


-- 
Jean Delvare
Suse L3

