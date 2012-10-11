Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab2JKNVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:21:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab2JKNVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:21:12 -0400
Date: Thu, 11 Oct 2012 15:21:11 +0200
From: Michal Marek <mmarek@suse.cz>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Nicolas Palix <nicolas.palix@imag.fr>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 v2] Update SmPL/Coccinelle section of MAINTAINERS
Message-ID: <20121011132111.GD16465@sepie.suse.cz>
References: <CAAxaTiOF8-jbgwboDTm9jODTq8qww91Bb3VG21ocEeDYbkXTMw@mail.gmail.com>
 <alpine.DEB.2.02.1209202257040.2848@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1209202257040.2848@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 10:57:33PM +0200, Julia Lawall wrote:
> On Thu, 20 Sep 2012, Nicolas Palix wrote:
> 
> >This patch updates some email addresses and the new
> >mailing list address.
> >
> >Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
> >---
> >v2: I changed the email address of Julia to use the capitalized version.
> >
> >MAINTAINERS | 6 +++---
> >1 file changed, 3 insertions(+), 3 deletions(-)
> >
> >diff --git a/MAINTAINERS b/MAINTAINERS
> >index b17587d..4b1bf08 100644
> >--- a/MAINTAINERS
> >+++ b/MAINTAINERS
> >@@ -1923,10 +1923,10 @@ S:	Supported
> >F:	drivers/platform/x86/classmate-laptop.c
> >
> >COCCINELLE/Semantic Patches (SmPL)
> >-M:	Julia Lawall <julia@diku.dk>
> >+M:	Julia Lawall <Julia.Lawall@lip6.fr>
> >M:	Gilles Muller <Gilles.Muller@lip6.fr>
> >-M:	Nicolas Palix <npalix.work@gmail.com>
> >-L:	cocci@diku.dk (moderated for non-subscribers)
> >+M:	Nicolas Palix <nicolas.palix@imag.fr>
> >+L:	cocci@systeme.lip6.fr (moderated for non-subscribers)
> >W:	http://coccinelle.lip6.fr/
> >S:	Supported
> >F:	scripts/coccinelle/
> >-- 
> >1.7.11.3
> >
> 
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Added to kbuild.git#misc, thanks.

Michal
