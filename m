Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab2FLWxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:53:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53948 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2FLWxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:53:50 -0400
Date: Wed, 13 Jun 2012 00:53:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <bp@alien8.de>, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org, hpa@zytor.com,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH 1/2] x86: Track minimum microcode revision globally v2
Message-ID: <20120612225344.GE11413@one.firstfloor.org>
References: <1339536350-10463-1-git-send-email-andi@firstfloor.org> <20120612213905.GE26817@liondog.tnic> <4FD7BE15.50604@linux.intel.com> <20120612221931.GA4376@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612221931.GA4376@liondog.tnic>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 12:19:31AM +0200, Borislav Petkov wrote:
> On Tue, Jun 12, 2012 at 03:09:25PM -0700, Andi Kleen wrote:
> > 
> > >Ok, is it only me or is this boot_min_microcode superfluous?
> > >IOW, you can only use boot_cpu_data.microcode instead and drop
> > >boot_min_microcode.
> > 
> > boot_cpu_data.microcode contains a copy of the original microcode,
> > so we couldn't detect the boot cpu case. In theory could hard code
> > CPU #0 is boot cpu or so,
> > but I prefer to track it with the separate variable.
> 
> Ok, this begs the next question then: why do we need to say that some AP
> has a lower ucode version than the BSP?

I would consider that a BIOS bug.

-Andi
