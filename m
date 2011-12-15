Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab1LORqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:46:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758942Ab1LORqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:46:31 -0500
Date: Thu, 15 Dec 2011 18:46:30 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/3]arch:powerpc:sysdev:mpic.c Remove extra semicolon.
In-Reply-To: <4EEA2A5A.2050008@gmail.com>
Message-ID: <alpine.LNX.2.00.1112151845550.23478@pobox.suse.cz>
References: <1321893808-3721-1-git-send-email-justinmattock@gmail.com> <4EEA2A5A.2050008@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Dec 2011, Justin P. Mattock wrote:

> what would be the status of these? should I resend/rebase to the current
> etc?..

Check linux-next, it's already there.

> 
> On 11/21/2011 08:43 AM, Justin P. Mattock wrote:
> > From: "Justin P. Mattock"<justinmattock@gmail.com>
> > 
> > The patch below removes an extra semicolon.
> > 
> > Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> > CC: linuxppc-dev@lists.ozlabs.org
> > CC: Paul Mackerras<paulus@samba.org>
> > ---
> >   arch/powerpc/sysdev/mpic.c |    2 +-
> >   1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
> > index 8c7e852..b3fa3d7 100644
> > --- a/arch/powerpc/sysdev/mpic.c
> > +++ b/arch/powerpc/sysdev/mpic.c
> > @@ -901,7 +901,7 @@ int mpic_set_irq_type(struct irq_data *d, unsigned int
> > flow_type)
> >   	if (vold != vnew)
> >   		mpic_irq_write(src, MPIC_INFO(IRQ_VECTOR_PRI), vnew);
> > 
> > -	return IRQ_SET_MASK_OK_NOCOPY;;
> > +	return IRQ_SET_MASK_OK_NOCOPY;
> >   }
> > 
> >   void mpic_set_vector(unsigned int virq, unsigned int vector)
> 

-- 
Jiri Kosina
SUSE Labs
