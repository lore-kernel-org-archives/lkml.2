Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab0G1CfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 22:35:18 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:57123 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458Ab0G1CfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 22:35:15 -0400
Date: Wed, 28 Jul 2010 03:35:01 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbdev: Make jz4740-fb depends on MACH_JZ4740
Message-ID: <20100728023500.GA7530@linux-mips.org>
References: <20100727111422.673b4919.sfr@canb.auug.org.au>
 <1280197979-24307-1-git-send-email-lars@metafoo.de>
 <20100727055546.GA5469@linux-mips.org>
 <20100728113136.97942d63.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728113136.97942d63.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 11:31:36AM +1000, Stephen Rothwell wrote:

> On Tue, 27 Jul 2010 06:55:46 +0100 Ralf Baechle <ralf@linux-mips.org> wrote:
> >
> > On Tue, Jul 27, 2010 at 04:32:59AM +0200, Lars-Peter Clausen wrote:
> > 
> > > The jz4740-fb driver should only be selectabed of MACH_JZ4740 is selected.
> > 
> > Thanks, folded into the original patch.
> 
> But it didn't make it into your mips-for-linux-next branch today?

Fixed.  Sorry.

  Ralf
