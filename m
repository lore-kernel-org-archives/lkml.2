Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab2GHQDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 12:03:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38801 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165Ab2GHQDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 12:03:37 -0400
Date: Sun, 8 Jul 2012 17:03:12 +0100
From: Will Deacon <will.deacon@arm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: remove asm/locks.h
Message-ID: <20120708160258.GC27030@mudshark.cambridge.arm.com>
References: <1341262188.1911.147.camel@x61.thuisdomein>
 <20120702215203.GA25234@mudshark.cambridge.arm.com>
 <1341300030.1911.179.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341300030.1911.179.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 08:20:30AM +0100, Paul Bolle wrote:
> On Mon, 2012-07-02 at 22:52 +0100, Will Deacon wrote:
> > Not sure I follow, but since this is all dead code I can't see any tests
> > failing without it.
> 
> The purpose of that disclaimer is to stress that only git commands were
> used to determine that removing this header is correct and safe. But
> perhaps saying that I therefore "tested" this patch with git commands is
> confusing.

Okey doke. Please can you put this into the patch system?

Cheers,

Will
