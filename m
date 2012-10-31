Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab2JaRh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:37:56 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37843 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758750Ab2JaRhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:37:53 -0400
Date: Wed, 31 Oct 2012 17:37:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121031173750.GB18615@srcf.ucam.org>
References: <20121029174131.GC7580@srcf.ucam.org>
 <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
 <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
 <20121031155503.1aaf4c93@pyramind.ukuu.org.uk>
 <alpine.LNX.2.00.1210311653080.12781@pobox.suse.cz>
 <20121031170334.59833fb1@pyramind.ukuu.org.uk>
 <20121031171048.GA17163@srcf.ucam.org>
 <20121031172121.14cc1215@pyramind.ukuu.org.uk>
 <20121031171743.GA17652@srcf.ucam.org>
 <20121031173919.4fc63ddd@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031173919.4fc63ddd@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 05:39:19PM +0000, Alan Cox wrote:
> On Wed, 31 Oct 2012 17:17:43 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > By booting a signed kernel, not turning on swap and writing directly to 
> > the swap partition.
> 
> Ok so the actual problem is that you are signing kernels that allow the
> user to skip the S4 resume check ?

What S4 resume check?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
