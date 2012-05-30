Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab2E3Rvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:51:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53403 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240Ab2E3Rvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:51:53 -0400
Date: Wed, 30 May 2012 19:51:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120530175150.GE15438@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Jacob Shin <jacob.shin@amd.com>,
	Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
	xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
	Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <4FC63DAF0200007800086DC5@nat28.tlf.novell.com>
 <4FC62888.9010407@amd.com>
 <20120530144851.GA12184@jshin-Toonie>
 <20120530145005.GI3207@phenom.dumpdata.com>
 <20120530150334.GA13349@jshin-Toonie>
 <20120530171754.GA5115@phenom.dumpdata.com>
 <20120530173247.GC15635@x1.osrc.amd.com>
 <4FC65D34.1060803@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FC65D34.1060803@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 10:47:32AM -0700, H. Peter Anvin wrote:
> > I wouldn't do that. Andre's patch switches to the
> > rdmsrl_safe/checking_wrmsrl functions so you don't need to implement the
> > _regs functions for pvops.
> > 
> But we just stated - it is wrong for K8?

Not executed on K8 - only on F15h, models 0x10 - 0x1f.

-- 
Regards/Gruss,
Boris.
