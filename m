Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab2HAO0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:26:37 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55464 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2HAO0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:26:35 -0400
Date: Wed, 1 Aug 2012 15:26:16 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] Fix priority of non-BAR ROM data
Message-ID: <20120801142616.GA31332@srcf.ucam.org>
References: <1343407934-459-1-git-send-email-mjg@redhat.com>
 <1343407934-459-3-git-send-email-mjg@redhat.com>
 <1343598582.15288.4.camel@shinybook.infradead.org>
 <20120729215301.GA27358@srcf.ucam.org>
 <CAErSpo7KKgrtL1ti5dYnykTMiKU2Gf-pviMFqBombdqGih98JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7KKgrtL1ti5dYnykTMiKU2Gf-pviMFqBombdqGih98JA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 08:20:15AM -0600, Bjorn Helgaas wrote:
> On Sun, Jul 29, 2012 at 3:53 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Sun, Jul 29, 2012 at 10:49:42PM +0100, David Woodhouse wrote:
> >> +      * Some devices may provide ROMs via a source other than the BAR
> >> +      */
> >> +     if (pdev->rom && pdev->romlen) {
> >> +             *size = pdev->romlen;
> >> +             return phys_to_virt(pdev->rom);
> >
> > Needs casting. My mistake.
> 
> Matthew, are you going to fold this into your patch and repost your
> series, or is this a logically separate issue?

I can fold it in.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
