Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1KIJz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 04:55:29 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:38206 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753549Ab1KIJz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 04:55:27 -0500
Date: Wed, 9 Nov 2011 09:54:14 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Michal Marek <mmarek@suse.cz>
Cc: David Daney <ddaney.cavm@gmail.com>, Arnaud Lacombe <lacombar@gmail.com>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "Daney, David" <David.Daney@caviumnetworks.com>
Subject: Re: [PATCH] Kbuild: append missing-syscalls to the default target
 list
Message-ID: <20111109095414.GA15438@linux-mips.org>
References: <1314234210-11090-1-git-send-email-lacombar@gmail.com>
 <4E69FEC9.2080204@suse.cz>
 <CACqU3MUFyn_jh2pN4GLENqcGVUzAwcMJUR_WLY2EtqOhMheceQ@mail.gmail.com>
 <20111101232233.GA32441@sepie.suse.cz>
 <20111107204448.GA9949@linux-mips.org>
 <20111107211900.GB6264@sepie.suse.cz>
 <20111107233330.GA26705@linux-mips.org>
 <4EB8E75D.1010706@suse.cz>
 <4EB97333.1050403@gmail.com>
 <4EB9AD98.3010404@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB9AD98.3010404@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 11:30:48PM +0100, Michal Marek wrote:

> On 8.11.2011 19:21, David Daney wrote:
> > The problem is that compiler options meant to be used only for the 
> > compiling done by scripts/checksyscalls.sh are now leaking into the 
> > compilation of other parts of the kernel (asm-offsets.c), where they 
> > wreak havoc.
> > 
> > Something like the attached is what I think needs to be done.
> 
> Ah, right. That makes a lot of sense now. Ralf, does the patch at
> https://lkml.org/lkml/2011/11/8/312 work for you?

Yes, it does - and unlike David's first version this one also looks
reasonably elegant.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
