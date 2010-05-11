Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab0EKPM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:12:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237Ab0EKPMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:12:21 -0400
Date: Tue, 11 May 2010 08:02:32 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [98/98] MIPS: uasm: Add OR instruction.
Message-ID: <20100511150232.GA14895@suse.de>
References: <20100510223543.205125755@kvm.kroah.org>
 <4BE94543.3030204@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE94543.3030204@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 01:53:39PM +0200, Stefan Bader wrote:
> That seems to fail to apply to a 2.6.32.12 tree

Doh, you are right, I tried, and it failed.  I'll just drop it for now,
as it wasn't applied to the .33 tree either.

It didn't show up in the patch on kernel.org either.

Sorry about that.

greg k-h
