Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab1EMKPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:15:55 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:44695 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756792Ab1EMKPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:15:53 -0400
Date: Fri, 13 May 2011 11:17:16 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Kevin Cernekee <cernekee@gmail.com>, Wu Zhangjin <wuzhangjin@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Squash pci_fixup_irqs() compiler warning
Message-ID: <20110513101716.GB25345@linux-mips.org>
References: <cb01d61712b1374a8c62bc765094ea7e@localhost>
 <4DAC7499.5000602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAC7499.5000602@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:27:53AM -0700, David Daney wrote:

> >It's been two years since the original discussion, and the warning is
> >still there.  It is now the only warning left in my kernel build.
> >
> >I was hoping we could get this resolved for good (one way or another).

[...]

> NAK.
> 
> I think Ralf's idea in the e-mail you referenced is the proper approach.
> 
> Change pci_fixup_irqs(...) to take a 'const struct pci_dev *'
> instead. There is a lot of work going on in the kernel to constify
> things.  This should be fairly easy to get accepted.

It's a fairly big manual job but should be just right for spatch.

  Ralf
