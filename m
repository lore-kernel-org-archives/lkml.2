Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab2GaWLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 18:11:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57612 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab2GaWLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 18:11:18 -0400
Date: Wed, 1 Aug 2012 00:11:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: awful kconfig help texts.
Message-ID: <20120731221113.GA10201@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Thierry Reding <thierry.reding@avionic-design.de>
References: <20120731151600.GA19412@redhat.com>
 <20120731170741.GA4735@x1.osrc.amd.com>
 <20120731184313.GA30493@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120731184313.GA30493@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 02:43:13PM -0400, Dave Jones wrote:
> On Tue, Jul 31, 2012 at 07:07:41PM +0200, Borislav Petkov wrote:
>  > Oh, there's one more enlightening sentence in the help:
>  > 
>  > "You only need to enable this, if you also want to enable one or more of
>  > the PWM drivers below."
>  > 
>  > Got it? :-)
> 
> No, it doesn't add anything useful at all.

Sorry, I think you misunderstood me and I didn't express my irony
adequately - I was trying to be ironic, maybe even sarcastic here. But
that's hard to convey in written form.

> I know PWM is probably pulse width modulation, but why would my kernel
> need to care about this ? Why would I need drivers for it ?
>
> Also, think about what happens with 'oldconfig'. You don't get to even
> see 'the drivers below' until you've answered this question.
>
> It couldn't be more opaque if it tried.

I agree with all you've said and you're preaching to the choir. Sorry
that I didn't make my sarcasm more explicit.

Thanks.

-- 
Regards/Gruss,
    Boris.
