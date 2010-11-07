Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab0KGVvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:51:05 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45984 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0KGVvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:51:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Hk6ZhTip97V/CeXr0+JB+Tq8LdsSQ6GKR+lXOL6GDv6yn780UBeoGjXjmYWvGOiV9Z
         i30aktLrCAwaVnPtTiI64MHwPHTI1rq4y06PXkHvXm6oUFcoHxeJUogQxoTlaeGbG4yn
         wWuu5u0hBrmHFfGLcivlkajpUStz+TzaQskyI=
Date: Mon, 8 Nov 2010 00:51:00 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf, ui: Eliminate stack-smashing protection compiler
	complain
Message-ID: <20101107215100.GH13175@lenovo>
References: <20101106084724.GA5956@lenovo> <20101107214900.GE11134@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101107214900.GE11134@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 10:49:02PM +0100, Frederic Weisbecker wrote:
> On Sat, Nov 06, 2010 at 11:47:24AM +0300, Cyrill Gorcunov wrote:
> >  The gcc complains on Yes, No being allocated from stack space. Make
> > them conts to feel compiler happy.
> > 
> >  |    CC util/ui/util.o
> >  | cc1: warnings being treated as errors
> >  | util/ui/util.c: In function ‘ui__dialog_yesno’:
> >  | util/ui/util.c:108: error: not protecting function: no buffer at least 8 bytes long
> >  | make: *** [util/ui/util.o] Error 1
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > CC: Arnaldo Carvalho de Melo <acme@redhat.com>
> > CC: Frédéric Weisbecker <fweisbec@gmail.com>
> > CC: Ingo Molnar <mingo@elte.hu>
> > ---
> 
> I hope we can finally queue this one fix, the warning is there
> for a while now, and this patch looks quite sensible :)
> 

yup, thanks for review ;)
