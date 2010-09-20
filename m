Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab0ITPUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:20:35 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54989 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab0ITPUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:20:34 -0400
Date: Mon, 20 Sep 2010 17:20:25 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 1/2] x86, cpuid: Unbreak CPB CPUID feature
Message-ID: <20100920152025.GA4999@aftab>
References: <20100920140521.GA4823@aftab>
 <4C977979.2060301@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C977979.2060301@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, Sep 20, 2010 at 11:10:49AM -0400

> On 09/20/2010 07:05 AM, Borislav Petkov wrote:
> > 5958f1d5d722df7a9e5d129676614a8e5219bacd added mistakenly the CPB bit to
> > the common scattered CPUID features. Move it to AMD-only code where it
> > belongs.
> 
> I already asked for more information about this.

?? When? I prepped this one a couple of hours ago... Am I missing something?

> This patch, without a further description, makes absolutely no sense,
> and is furthermore implemented poorly -- I really don't want more ad
> hoc code if it can be avoided.

Well, I use the feature bit in powernow-k8.c. We don't need to advertize
it in /proc/cpuinfo per se if that's what you prefer?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
