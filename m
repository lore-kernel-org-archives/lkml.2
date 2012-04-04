Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab2DDQp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 12:45:58 -0400
Received: from trent.utfs.org ([94.185.90.103]:53933 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab2DDQp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 12:45:57 -0400
Date: Wed, 4 Apr 2012 09:45:49 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
cc: linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.4.0-rc1: No init found
In-Reply-To: <4F7C4058.6090405@in.ibm.com>
Message-ID: <alpine.DEB.2.01.1204040944210.4930@trent.utfs.org>
References: <alpine.DEB.2.01.1204030008080.4930@trent.utfs.org> <1333440522.3040.9.camel@pasglop> <alpine.DEB.2.01.1204030953320.4930@trent.utfs.org> <4F7C4058.6090405@in.ibm.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2012 at 18:06, Suzuki K. Poulose wrote:
> > INFO: Uncompressed kernel (size 0x6d4b80) overlaps the address of the
> > wrapper(0x400000)
> > INFO: Fixing the link_address of wrapper to (0x700000)
> >    Building modules, stage 2.
> >    MODPOST 24 modules
> > ------------
> > 
> > I started to see these messages in January (around Linux 3.2.0), but never
> > investigated what it was since the produced kernels continued to boot just
> > fine.
> 
> The above change was added by me. The message is printed when the 'wrapper'
> script finds that decompressed kernel overlaps the 'bootstrap code' which does
> the decompression. So it shifts the 'address' of the bootstrap code to the
> next higher MB. As such it is harmless.

OK, good to know that it's harmless. Thanks for the explanation.

Christian.
-- 
BOFH excuse #256:

You need to install an RTFM interface.
