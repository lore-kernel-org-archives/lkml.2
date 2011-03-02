Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab1CBMtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 07:49:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:29299 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899Ab1CBMtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 07:49:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,253,1297065600"; 
   d="scan'208";a="608200195"
Date: Wed, 2 Mar 2011 20:49:12 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [tip:x86/mm] x86: Work around old gas bug
Message-ID: <20110302124912.GB23940@sli10-conroe.sh.intel.com>
References: <201103012352.p21NqRN1006974@imap1.linux-foundation.org>
 <tip-253d89d3dd6b65595f317e5f1ecef43aa207a3a0@git.kernel.org>
 <4D6E2B8B02000078000347C0@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6E2B8B02000078000347C0@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 06:35:39PM +0800, Jan Beulich wrote:
> >>> On 02.03.11 at 09:42, tip-bot for Shaohua Li <shaohua.li@intel.com> wrote:
> > Commit-ID:  253d89d3dd6b65595f317e5f1ecef43aa207a3a0
> > Gitweb:
> > http://git.kernel.org/tip/253d89d3dd6b65595f317e5f1ecef43aa207a3a0
> > Author:     Shaohua Li <shaohua.li@intel.com>
> > AuthorDate: Tue, 1 Mar 2011 15:52:26 -0800
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 2 Mar 2011 08:16:23 +0100
> >
> > x86: Work around old gas bug
> >
> > pre-2.16 binutils works fine, post-2.16 binutils works fine, but 2.16 broke
> > again:
> >
> >  > arch/x86/kernel/entry_64.S: Assembler messages:
> >  > arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first
> > unrecognized character is `1'
> >  > [...]
> >
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Jan Beulich <jbeulich@novell.com>
> > LKML-Reference: <201103012352.p21NqRN1006974@imap1.linux-foundation.org>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Ingo, didn't you write yesterday that this looks unacceptable to
> you?
> 
> Shaohua, did you try whether the .irpc alternative I suggested
> works (knowing that a similar .irpc was in place previously)?
I tried, but fails at early stage (not related to the problem). According
to HPA, I need rebuild gcc too, which I haven't done yet.

Thanks,
Shaohua
