Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab1BJW5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 17:57:12 -0500
Received: from www.tglx.de ([62.245.132.106]:59127 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756844Ab1BJW5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 17:57:10 -0500
Date: Thu, 10 Feb 2011 23:56:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: liqin.chen@sunplusct.com
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] score: Select GENERIC_HARDIRQS_NO_DEPRECATED
In-Reply-To: <OF6CAF901B.FBFD5FE8-ON48257833.0025EC26-48257833.00260476@sunplusct.com>
Message-ID: <alpine.LFD.2.00.1102102355570.31804@localhost6.localdomain6>
References: <OF6CAF901B.FBFD5FE8-ON48257833.0025EC26-48257833.00260476@sunplusct.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-207249132-1297378603=:31804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-207249132-1297378603=:31804
Content-Type: TEXT/PLAIN; charset=GB2312
Content-Transfer-Encoding: 8BIT

On Thu, 10 Feb 2011, liqin.chen@sunplusct.com wrote:

> Thomas Gleixner <tglx@linutronix.de> Ð´ÓÚ 2011-02-07 06:23:50:
> 
> > All chips converted and proper accessor functions used.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  arch/score/Kconfig |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Index: linux-next/arch/score/Kconfig
> > ===================================================================
> > --- linux-next.orig/arch/score/Kconfig
> > +++ linux-next/arch/score/Kconfig
> > @@ -3,6 +3,7 @@ menu "Machine selection"
> >  config SCORE
> >         def_bool y
> >         select HAVE_GENERIC_HARDIRQS
> > +       select GENERIC_HARDIRQS_NO_DEPRECATED
> > 
> >  choice
> >     prompt "System type"
> > 
> > 
> 
> Acked-by: Chen Liqin <liqin.chen@sunplusct.com>

Can you take that through your tree for .39 ?

Thanks,

	tglx
---1463795968-207249132-1297378603=:31804--
