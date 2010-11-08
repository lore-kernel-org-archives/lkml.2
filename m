Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0KIEYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 23:24:24 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:56808 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab0KIEYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 23:24:23 -0500
Date: Mon, 8 Nov 2010 22:44:04 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS VPE support module: don't deref potentially null
 pbuffer and don't do pointless null check before vfree
Message-ID: <20101108224404.GA6689@linux-mips.org>
References: <alpine.LNX.2.00.1010301823350.1572@swampdragon.chaosbits.net>
 <20101107142933.GA7999@linux-mips.org>
 <alpine.LNX.2.00.1011071943460.26247@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011071943460.26247@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 07:48:25PM +0100, Jesper Juhl wrote:

> I've taken a second look. I still have no way at all to test this, so 
> please take a close look before potentially applying it, but how does this 
> look to you?

Testing is a little tricky - it requires a MIPS 34K processor in a
configuration with more than one VPE.

> Don't dereference pbuffer before ttesting it for null.
> Don't do pointless check of pointer passed to vfree for null as vfree does 
> this itself.

I've already checked in something based on your first patch with the
other changes I suggested added.

Thanks!

  Ralf
