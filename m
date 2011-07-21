Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1GUT56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:57:58 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:54585 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751296Ab1GUT5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:57:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cVPEODFyvd6y4v5W9j/Xe3vo5N5GQYtlkz6sL6Wfx6pEbQodhmgKuOwyWMVaAHOPunS0lZfnnzSmU3nLXh1Ep2DzTfaf6qmGLieCdO6jkuFCbliYeElWroQUAF7EaVOD;
Date: Thu, 21 Jul 2011 12:57:49 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <JBeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: constify PCI raw ops structures
Message-ID: <20110721125749.73cfdf6b@jbarnes-desktop>
In-Reply-To: <20110721070459.GB9216@elte.hu>
References: <4E258C82020000780004E3C2@nat28.tlf.novell.com>
	<20110721070459.GB9216@elte.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 09:04:59 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jan Beulich <JBeulich@novell.com> wrote:
> 
> > As with any other such change, the goal is to prevent inadvertent
> > writes to these structures (assuming DEBUG_RODATA is enabled), and to
> > separate data (possibly frequently) written to from such never getting
> > modified.
> > 
> > Signed-off-by: Jan Beulich <jbeulich@novell.com>
> > 
> > ---
> >  arch/x86/include/asm/pci_x86.h |    6 +++---
> >  arch/x86/pci/ce4100.c          |    2 +-
> >  arch/x86/pci/common.c          |    4 ++--
> >  arch/x86/pci/direct.c          |    6 +++---
> >  arch/x86/pci/mmconfig_32.c     |    2 +-
> >  arch/x86/pci/mmconfig_64.c     |    2 +-
> >  arch/x86/pci/numaq_32.c        |    2 +-
> >  arch/x86/pci/olpc.c            |    2 +-
> >  arch/x86/pci/pcbios.c          |    4 ++--
> >  9 files changed, 15 insertions(+), 15 deletions(-)
> 
> Reviewed-by: Ingo Molnar <mingo@elte.hu>
> 
> It's a patch for Jesse's PCI tree i suspect.

Yep, I like it, I'll add it to my queue.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
