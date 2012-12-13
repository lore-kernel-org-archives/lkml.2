Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2LMTNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 14:13:21 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42041 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab2LMTNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 14:13:19 -0500
Date: Thu, 13 Dec 2012 20:13:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
Message-ID: <20121213191317.GE31485@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
	"mingo@kernel.org" <mingo@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@linux.intel.com" <hpa@linux.intel.com>,
	"linux-tip-commits@vger.kernel.org" <linux-tip-commits@vger.kernel.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
References: <20121211170605.GD28827@liondog.tnic>
 <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
 <50C76F9E.4080001@zytor.com>
 <CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com>
 <50C7C859.60405@zytor.com>
 <CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com>
 <50C82ABF.3020907@zytor.com>
 <20121212133853.GC8760@liondog.tnic>
 <50C963B1.3040609@zytor.com>
 <50C96717.3020407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50C96717.3020407@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 09:26:47PM -0800, H. Peter Anvin wrote:
> On 12/12/2012 09:12 PM, H. Peter Anvin wrote:
> >Here is a version that compiles.  It doesn't *boot* yet, because the
> >switchover from dynamic mode to the real pagetables doesn't happen right
> >and so we end up on an uninitialized set of page tables.
> >
> >The new page table setup in tip:x86/mm2 should make that easier to
> >achieve, however... I won't have time to test this out tonight, though.
> >
> >     -hpa
> 
> Well, minus a simple brainfart now it actually gets into the page
> table setup.

If by this you mean that you can only see

"Decompressing Linux...
Parsing ELF.."

and then the VM reboots (running it in KVM) then ok, I'm seeing this
here too.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
