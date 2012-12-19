Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab2LSXAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:00:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60610 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab2LSXAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:00:17 -0500
Date: Thu, 20 Dec 2012 00:00:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
Message-ID: <20121219230015.GL24895@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jacob Shin <jacob.shin@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Yinghai Lu <yinghai@kernel.org>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
	"mingo@kernel.org" <mingo@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"linux-tip-commits@vger.kernel.org" <linux-tip-commits@vger.kernel.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
References: <CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com>
 <50CCEE49.3080801@zytor.com>
 <CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com>
 <50CCF6F6.4020107@zytor.com>
 <CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com>
 <50CD04F1.8020902@zytor.com>
 <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com>
 <20121219220504.GA32212@jshin-Toonie>
 <50D23EE8.7030904@zytor.com>
 <20121219225505.GA2968@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121219225505.GA2968@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 04:55:06PM -0600, Jacob Shin wrote:
> Well, really the problem is with any memory hole above 4GB that is too
> big to be covered by variable range MTRRs as UC.

Why, their PhysBase field is the 40 MSB bits of the physical address.
That should be more than TB.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
