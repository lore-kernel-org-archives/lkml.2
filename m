Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab0EXN7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 09:59:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52378 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757137Ab0EXN7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 09:59:52 -0400
Date: Mon, 24 May 2010 14:59:40 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ben Skeggs <bskeggs@redhat.com>,
       dri-devel@lists.freedesktop.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH -next] nouveau: fix acpi_lid_open undefined
Message-ID: <20100524135940.GA15892@srcf.ucam.org>
References: <20100522170459.4c89723d.sfr@canb.auug.org.au> <20100523170040.3c4aa87c.randy.dunlap@oracle.com> <20100524125628.GA14278@srcf.ucam.org> <4BFA84EF.7070609@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFA84EF.7070609@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 06:53:51AM -0700, Randy Dunlap wrote:
> On 05/24/10 05:56, Matthew Garrett wrote:
> > Won't this result in a behavioural difference? The desirable outcome is 
> 
> It could, yes.
> 
> > that that configuration be impossible, not for that configuration to 
> > build but be buggy.
> 
> so nouveau should depend on (or select, if ACPI is enabled) ACPI_BUTTON?

There's an argument that it doesn't need to depend on it, but if button 
is a module then nouveau has to be. Except the inverse isn't true. 
Kconfig is hard, let's weep gently.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
