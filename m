Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab2FLVDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:03:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53869 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2FLVDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:03:33 -0400
Date: Tue, 12 Jun 2012 23:03:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] x86: Track minimum microcode revision globally
Message-ID: <20120612210329.GD11413@one.firstfloor.org>
References: <1339533234-2265-1-git-send-email-andi@firstfloor.org> <20120612204917.GA26817@liondog.tnic> <4FD7ABFE.6090801@zytor.com> <20120612205956.GB26817@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612205956.GB26817@liondog.tnic>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 10:59:56PM +0200, Borislav Petkov wrote:
> On Tue, Jun 12, 2012 at 01:52:14PM -0700, H. Peter Anvin wrote:
> > Different CPUs in a multisocket system may have different compatible
> > ucode versions.
> 
> Ah, so you need the different ucode for the different steppings of the
> cpus on the board, right? Assuming ucode versions are incremented per
> F:M:S tuple, of course, then you can have different compatible microcode
> versions.

I believe just for different models. Different models in a single system
may be possible, but are quite unsupported. The code doesn't
handle that, but I don't really worry about that.

> > Of course, I am not even sure if it makes any sense at all to compare
> > microcode versions without qualifying them with F:M:S.

It doesn't.

But I think this model handles 99.999% of all sane configs, don't
really want to complicate it more.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
