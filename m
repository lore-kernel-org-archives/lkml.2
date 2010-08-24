Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab0HXMG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 08:06:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56668 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0HXMG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 08:06:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: 64-bit ppc rwsem
Date: Tue, 24 Aug 2010 14:06:38 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, linuxppc-dev@lists.ozlabs.org,
        torvalds@linux-foundation.org, paulus@au.ibm.com,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        akpm@linux-foundation.org
References: <20100818.222925.233689776.davem@davemloft.net> <20100823.151853.108794567.davem@davemloft.net> <1282613477.22370.485.camel@pasglop>
In-Reply-To: <1282613477.22370.485.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008241406.38539.arnd@arndb.de>
X-Provags-ID: V02:K0:DW1WXj35mtWiGH/38TMntlUMuLew8SgNoCHcdOo0n4X
 V7OGMzhYL9MVu3mTwISLE5csMBibXIT/YOsx5hx7z2/QM+USOr
 lBdCFjr9bdRabWihufV2JdPs3zAKq1pIxTGWoRL95n4KRr+7ux
 3jCP6AGaPF/Qwo+jmKc+kluKUiD/OVmucWLdY2udYM47SIH9Z5
 5JnrralTSEjUxJB24nVrw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 August 2010, Benjamin Herrenschmidt wrote:
> On Mon, 2010-08-23 at 15:18 -0700, David Miller wrote:
> > > I've seen drivers in the past do trylocks at interrupt time ... tho
> > I
> > > agree it sucks.
> > 
> > Recently there was a thread where this was declared absolutely
> > illegal.
> > 
> > Maybe it was allowed, or sort-of worked before, and that's why it's
> > accounted for with IRQ disables in some implementations.  I don't
> > know. 
> 
> Ok, I'm happy to say it's a big no-no then.
> 
> Arnd, do you want to take over the moving to asm-generic and take care
> of the spinlock case as well ? I can send Linus the first patch that
> changes powerpc to use atomic_long now along with a few other things I
> have pending, then you can pickup from there. Or do you want me to
> continue pushing my patch as-is and we can look at cleaning up the
> spinlock case separately ?

I'm currently doing too many things at once, please push in your existing
patch for now, we can continue from there.

For the asm-generic patch:
Acked-by: Arnd Bergmann <arnd@arndb.de>
