Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab2JaRRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:17:51 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33471 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab2JaRRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:17:48 -0400
Date: Wed, 31 Oct 2012 17:17:43 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121031171743.GA17652@srcf.ucam.org>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
 <20121029174131.GC7580@srcf.ucam.org>
 <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
 <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
 <20121031155503.1aaf4c93@pyramind.ukuu.org.uk>
 <alpine.LNX.2.00.1210311653080.12781@pobox.suse.cz>
 <20121031170334.59833fb1@pyramind.ukuu.org.uk>
 <20121031171048.GA17163@srcf.ucam.org>
 <20121031172121.14cc1215@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031172121.14cc1215@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 05:21:21PM +0000, Alan Cox wrote:
> On Wed, 31 Oct 2012 17:10:48 +0000
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > The kernel is signed. The kernel doesn't check the signature on the 
> > suspend image.
> 
> Which doesn't matter. How are you going to create the tampered image in
> the first place ?

By booting a signed kernel, not turning on swap and writing directly to 
the swap partition.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
