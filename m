Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab2FKJtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:49:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46147 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab2FKJtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:49:08 -0400
Date: Mon, 11 Jun 2012 11:49:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: Boszormenyi Zoltan <zboszor@pr.hu>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: AMD FX CPU bug, not fixed by latest microcode?
Message-ID: <20120611094905.GA10349@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Boszormenyi Zoltan <zboszor@pr.hu>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <4FD4F45D.5050103@pr.hu>
 <20120611084318.GA1685@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120611084318.GA1685@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 10:43:18AM +0200, Borislav Petkov wrote:
> On Sun, Jun 10, 2012 at 09:24:13PM +0200, Boszormenyi Zoltan wrote:
> > I have an AMD FX-8120 boxed CPU in an ASUS M5A99X-EVO mainboard
> > with 32GB DDR3/1600 memory, running Fedora 17, upgraded from 16.
> > memtest86+ show no problems.

Ohe other thing: if there's an option in the BIOS to disable the IOMMU,
can you do that and try reproducing the issue with IOMMU disabled?

Thanks.

-- 
Regards/Gruss,
    Boris.
