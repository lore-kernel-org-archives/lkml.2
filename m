Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934688Ab1JaWmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:42:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934441Ab1JaWmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:42:49 -0400
Date: Mon, 31 Oct 2011 23:42:48 +0100
From: Michal Marek <mmarek@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/17] drop unused Kconfig symbols
Message-ID: <20111031224248.GB25411@sepie.suse.cz>
References: <1319456255.2409.30.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319456255.2409.30.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 01:37:35PM +0200, Paul Bolle wrote:
> 0) This is what's left of the Kconfig patches that I send (to
> maintainers and lkml) ten days ago.
> 
> 1) I've dropped five patches that were taken by the maintainers
> (blackfin, unicore32, tomoyo, m68k, and staging). cris got a NAK (for an
> invalid reason, but I guess I'll just try again after the v3.2 merge
> window closes).
> 
> 2) I've added all the tags the rest of these patches collected.
> 
> 3) No further tests were done since I first send these (not that the
> tests done then were very thorough).
>  
> 4) I'll send these patches only to you and the people that added a tag.
> Please tell me if you'd like me to also cc lkml and the maintainers. I
> assumed cc'ing those addresses would not be helpful in this stage.
> 
> Paul Bolle (17):
>   alpha: drop unused Kconfig symbol
>   sparc: drop unused Kconfig symbol
>   um: drop unused Kconfig symbol
>   sh: drop unused Kconfig symbol
>   score: drop unused Kconfig symbols
>   m32r: drop unused Kconfig symbol
>   samples: drop unused Kconfig symbol
>   arm: at91: drop unused Kconfig symbol
>   (arm: drop unused Kconfig symbol -- skipped)
>   openrisc: drop unused Kconfig symbols
>   mips: drop unused Kconfig symbols
>   powerpc: 40x: drop unused Kconfig symbol
>   powerpc: drop unused Kconfig symbols
>   x86: drop unused Kconfig symbol
>   stmmac: drop unused Kconfig symbol
>   pci: drop unused Kconfig symbol
>   scsi: drop unused Kconfig symbol

Applied except for the one arm commit.

Michal
