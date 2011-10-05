Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934615Ab1JEMbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:31:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59306 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934330Ab1JEMbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:31:06 -0400
Date: Wed, 5 Oct 2011 14:31:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Valdis.Kletnieks@vt.edu
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        anderson@redhat.com, tachibana@mxm.nes.nec.co.jp,
        oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111005123102.GA509@gere.osrc.amd.com>
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <m162k64c7w.fsf@fess.ebiederm.org>
 <20111003120336.GK2223@in.ibm.com>
 <20111004063440.GB5723@liondog.tnic>
 <20111005070728.GA2235@in.ibm.com>
 <20111005073111.GA13478@liondog.tnic>
 <26571.1317815746@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26571.1317815746@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 07:55:46AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 05 Oct 2011 09:31:11 +0200, Borislav Petkov said:
> > On Wed, Oct 05, 2011 at 12:37:28PM +0530, K.Prasad wrote:
> 
> > > True. Like stated by me earlier, there could be two possible outcomes
> > > from capturing memory dump in such cases - they're either dangerous or
> > > doesn't make sense.
> >
> > Why, in the second example the only corruption is to the L2 cache so
> > your memory image is intact. Why wouldn't you want to capture a memory
> > dump then? It is business as usual in that case.
> 
> I'll bite.  What's the use case for bothering to capture a memory dump when
> you're looking at an MCE that indicates L2 cache corruption?  What additional
> useful information could you possibly get from the dump?

This was just a hypothetical example to show that you need a more
finer-grained differentiation between fatal MCEs when deciding to dump
or not to dump :-) and not to unconditionally _not_ dump just because
we're going to panic.

-- 
Regards/Gruss,
Boris.
