Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0KIS4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:56:18 -0500
Received: from smtp.outflux.net ([198.145.64.163]:59957 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab0KIS4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:56:14 -0500
Date: Tue, 9 Nov 2010 10:56:04 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Security] [PATCH v3 0/4] x86: clear XD_DISABLED flag on Intel
 to regain NX
Message-ID: <20101109185604.GK5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
 <20101109183142.4ebfa737@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109183142.4ebfa737@lxorguk.ukuu.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 06:31:42PM +0000, Alan Cox wrote:
> > In a review[1] of reported hardware being used by Ubuntu bug reporters,
> > almost 10% of systems had an incorrectly configured BIOS, leaving their
> > systems unable to use the NX features of their CPU.
> 
> Ouch

Yeah :(

> > This change will clear the MSR_IA32_MISC_ENABLE_XD_DISABLE bit so that NX
> > cannot be inappropriately controlled by the BIOS on Intel CPUs.  If, under
> > very strange hardware configurations, NX actually needs to be disabled,
> > "noexec=off" can be used to restore the prior behavior.
> 
> Have you done an audit of CPU errata to ensure that none of these cases
> are ones where the BIOS has disabled it to avoid an erratum. I'd hate to
> turn it on and find out the BIOS actually turned it off for good reason !

Where can I find those details?

-Kees

-- 
Kees Cook
Ubuntu Security Team
