Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1CCFgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 00:36:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718Ab1CCFgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 00:36:22 -0500
Date: Wed, 2 Mar 2011 21:35:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [tip:x86/mm] x86: Work around old gas bug
Message-Id: <20110302213553.88ec33cd.akpm@linux-foundation.org>
In-Reply-To: <1299130025.19589.89.camel@sli10-conroe>
References: <201103012352.p21NqRN1006974@imap1.linux-foundation.org>
	<tip-253d89d3dd6b65595f317e5f1ecef43aa207a3a0@git.kernel.org>
	<4D6E2B8B02000078000347C0@vpn.id2.novell.com>
	<20110302104144.GB25608@elte.hu>
	<20110302082453.934f2033.akpm@linux-foundation.org>
	<1299130025.19589.89.camel@sli10-conroe>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Mar 2011 13:27:05 +0800 Shaohua Li <shaohua.li@intel.com> wrote:

> On Thu, 2011-03-03 at 00:24 +0800, Andrew Morton wrote:
> > On Wed, 2 Mar 2011 11:41:44 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > Meanwhile, what i hate more than ugly code repetition is code that does not build at 
> > > all on akpm's test environment ;-)
> > 
> > I hadn't got around to testing it.  Bad news :(
> > 
> Andrew,
> can you this on your side? this is what Jan proposed. I can only test a
> latest binutils here.

Nope.

arch/x86/kernel/entry_64.S: Assembler messages:
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
arch/x86/kernel/entry_64.S:985: Error: too many positional arguments
