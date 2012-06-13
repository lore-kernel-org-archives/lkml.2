Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab2FMPgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:36:15 -0400
Received: from h9.dl5rb.org.uk ([81.2.74.9]:54620 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753453Ab2FMPgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:36:14 -0400
X-Greylist: delayed 2394 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2012 11:36:14 EDT
Date: Wed, 13 Jun 2012 15:56:15 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: remove three unused headers
Message-ID: <20120613145614.GC5516@linux-mips.org>
References: <1339491792.30984.110.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339491792.30984.110.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 11:03:12AM +0200, Paul Bolle wrote:

> No file includes these three headers. It seems they have never been
> included since at least v2.6.12-rc2. They can safely be removed.

>  arch/mips/include/asm/sibyte/sb1250_l2c.h |  131 -------
>  arch/mips/include/asm/sibyte/sb1250_ldt.h |  422 ----------------------
>  arch/mips/include/asm/sibyte/sb1250_mc.h  |  550 -----------------------------

These headers describe the on-chip hardware of the SB1250 SOC.  Some of
the drivers to use them are currently stuck midflight on their path to
submission.  The remaining ones I'd like to keep around as documentation
or for later use.  Ditto for your other BCM1480 related patch....

Thanks,

  Ralf
