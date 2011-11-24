Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1KXVIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 16:08:20 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52429 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab1KXVIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 16:08:19 -0500
Date: Thu, 24 Nov 2011 21:07:49 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Mike Waychison <mikew@google.com>,
        Andi Kleen <andi@firstfloor.org>, Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH v5 10/10] x86, efi: EFI boot stub support
Message-ID: <20111124210749.GA14428@srcf.ucam.org>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
 <1318848017-12301-11-git-send-email-matt@console-pimps.org>
 <4E9C8AAC.7080803@gmail.com>
 <1321383097.2657.9.camel@mfleming-mobl1.ger.corp.intel.com>
 <4ECC4207.3010607@gmail.com>
 <1322076468.24448.18.camel@mfleming-mobl1.ger.corp.intel.com>
 <4ECE5803.3060203@gmail.com>
 <1322168216.24448.61.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322168216.24448.61.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 08:56:56PM +0000, Matt Fleming wrote:

> Thanks a lot for diagnosing this, Maarten! The copy of grub that I have
> (fedora's version) looks like it uses the disk_io protocol to read from
> disks, I wonder if there's a reason for this. I Cc'd Peter Jones in case
> he's seen anything like this before.

grub needs to be able to read files off filesystems that may not be 
supported by the UEFI implementation, so has its own filesystem drivers 
that use disk_io.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
