Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab1FCOqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:46:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58252 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1FCOqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:46:51 -0400
Date: Fri, 3 Jun 2011 15:46:44 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jim Bos <jim876@xs4all.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110603144644.GA26782@srcf.ucam.org>
References: <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com>
 <4CE17C4B.1070305@xs4all.nl>
 <20101115185848.GI2583@sunsite.ms.mff.cuni.cz>
 <20101115191248.GY29412@tyan-ft48-01.lab.bos.redhat.com>
 <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com>
 <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com>
 <4CE1968D.3050706@xs4all.nl>
 <4DE8DC16.6030308@xs4all.nl>
 <20110603133351.GA25130@srcf.ucam.org>
 <4DE8EF13.9030609@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE8EF13.9030609@xs4all.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 04:26:27PM +0200, Jim Bos wrote:
> On 06/03/2011 03:33 PM, Matthew Garrett wrote:
> > ? You've got 143 boot services/code regions, which is more than I'd 
> > tested against, so I'm unsure whether we're overflowing something here.
> > 
> 
> That's seems to be the only EFI patch in 2.6.39.1 and I effectively
> removed by =not= applying (skipping) the parts of the 2.6.39.1 patch to
> above 3 files.
> So yes removing "x86, efi: Retain boot service code until after
> switching to virtual mode" indeed fixes the problem for me.

Ok, thanks. I'll look into that. Might be best to drop it from stable 
for the moment until I've made sure it works on machines with excessive 
maps.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
