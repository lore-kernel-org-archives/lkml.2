Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1KQS5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 13:57:42 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:47142 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab1KQS5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 13:57:40 -0500
Date: Thu, 17 Nov 2011 13:57:31 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/platform: (TS-5500) fix CONFIG_TS5500_ADC
 dependency
Message-ID: <20111117135731.1c8e736e@v0nbox>
In-Reply-To: <4EC554CA.5070802@zytor.com>
References: <1321555012-14331-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<4EC554CA.5070802@zytor.com>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011 10:39:06 -0800,
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 11/17/2011 10:36 AM, Vivien Didelot wrote:
> > Hi Ingo,
> > 
> > Here's the fix for the Kconfig dependency issue, for the TS-5500
> > platform. It is based on the latest x86/platform branch from the
> > -tip tree.
> > 
> > Best,
> > 
> >     Vivien
> > 
> > Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> > ---
> >  arch/x86/platform/ts5500/Kconfig |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/platform/ts5500/Kconfig
> > b/arch/x86/platform/ts5500/Kconfig index be51b86..84e59a9 100644
> > --- a/arch/x86/platform/ts5500/Kconfig
> > +++ b/arch/x86/platform/ts5500/Kconfig
> > @@ -23,6 +23,6 @@ config TS5500_LED
> >  
> >  config TS5500_ADC
> >  	bool "TS-5500 ADC"
> > -	depends on TS5500
> > +	depends on TS5500 && HWMON=y
> >  	help
> >        Support for the A/D converter on Technologic Systems TS-5500
> > SBCs.
> 
> Shouldn't this be a module, too?
> 
> 	-hpa
> 

IMHO it would be overkill for such a small embedded platform to provide
device drivers as modules.

Regards,

	Vivien
