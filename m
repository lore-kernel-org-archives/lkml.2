Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab2GaRHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:07:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40911 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab2GaRHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:07:40 -0400
Date: Tue, 31 Jul 2012 19:07:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: awful kconfig help texts.
Message-ID: <20120731170741.GA4735@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Thierry Reding <thierry.reding@avionic-design.de>
References: <20120731151600.GA19412@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120731151600.GA19412@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 11:16:00AM -0400, Dave Jones wrote:
> 
> PWM Support (PWM) [N/y/?] (NEW) ?
> 
> CONFIG_PWM:
> 
> This enables PWM support through the generic PWM framework.
> 
> 
> Well that's.. enlightening.

Oh, there's one more enlightening sentence in the help:

"You only need to enable this, if you also want to enable one or more of
the PWM drivers below."

Got it? :-)

> I'm picking on PWM here, but this isn't an
> isolated case.  Every merge window we see a slew of new options with useless
> help texts. They may as well be non-existent. (Actually in some cases, they are).
> 
> If someone has to read the code to find out what the driver is, your help text probably sucks.
> 
> 
> (I'll leave "why does this option even show up on x86" as a separate rant)

Thierry, can you guys please fix this?

Thanks.

-- 
Regards/Gruss,
Boris.
