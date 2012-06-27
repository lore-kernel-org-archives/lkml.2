Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab2F0TfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:35:09 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40404 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854Ab2F0TfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:35:07 -0400
Message-ID: <1340825704.3175.88.camel@dabdike.int.hansenpartnership.com>
Subject: Re: UEFI Secure boot using qemu-kvm
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Date: Wed, 27 Jun 2012 20:35:04 +0100
In-Reply-To: <20120627181503.GA7775@srcf.ucam.org>
References: <1340818445.3175.73.camel@dabdike.int.hansenpartnership.com>
	 <20120627181503.GA7775@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 19:15 +0100, Matthew Garrett wrote:
> On Wed, Jun 27, 2012 at 06:34:05PM +0100, James Bottomley wrote:
> 
> > The purpose of this email is to widen the pool of people who are playing
> > with UEFI Secure boot.  The Linux Foundation Technical Advisory Board
> > have been looking into this because it turns out to be rather difficult
> > to lay your hands on real UEFI Secure Boot enabled hardware.
> 
> http://tunnelmountain.net/ is the canonical source, but I believe that 
> these are now out of stock and waiting for Intel to finish the 
> firmware for the replacement.
> 
> > The current state is that I've managed to lock down the secure boot
> > virtual platform with my own PK and KEK and verified that I can generate
> > signed efi binaries that will run on it (and that it will refuse to run
> > unsigned efi binaries).  Finally I've demonstrated that I can sign
> > elilo.efi (this has to be built specially because of the bug in gnu-efi)
> > and have it boot an unsigned linux kernel when the platform is in secure
> > mode (I've booted up to an initrd root prompt).
> 
> It's probably worth noting that booting unsigned kernels violates the 
> expectations of various vendors 
> (http://msdn.microsoft.com/en-us/library/windows/desktop/hh848062%28v=vs.85%29.aspx 
> would be unnecessary if you're supporting unsigned kernels, for 
> example). There's no public cross-vendor guidance on this, but I'm 
> trying to get that rectified.
> 
> As well as sbsign there's also https://github.com/vathpela/pesign for 
> anyone stuck relying on nss rather than openssl for awkward regulatory 
> reasons.

I've tried to build pesign, but I have huge problems with the make
process; how did you build it?

However, sbsign (with four extra patches I've sent to Jeremy) seems to
be built and working.

James


