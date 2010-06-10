Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178Ab0FJSke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 14:40:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41415 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab0FJSkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 14:40:33 -0400
Date: Thu, 10 Jun 2010 19:40:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Rezwanul_Kabir@Dell.com
Cc: pharon@gmail.com, linux-kernel@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Dell Studio 1555 eject key does not work ( small patch to fix
	included )
Message-ID: <20100610184023.GA17320@srcf.ucam.org>
References: <AANLkTinG3jv6o8T00mDTEP5uxf4tKqOwSPEDIUcv4kVG@mail.gmail.com> <20100602213429.GA14866@srcf.ucam.org> <57DF5FDC2DC0634FA2A310BC5B81A68D01DF4CD01E@AUSX7MCPC108.AMER.DELL.COM> <AANLkTimIl6UL0HQT1wxRgXuj_m0O3CwMHQIa1xNE1Ax9@mail.gmail.com> <AANLkTin0qht1XR2rUgIXMEeJNU_gb3IZWqSBJb7NXD8K@mail.gmail.com> <57DF5FDC2DC0634FA2A310BC5B81A68D01DFD57663@AUSX7MCPC108.AMER.DELL.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57DF5FDC2DC0634FA2A310BC5B81A68D01DFD57663@AUSX7MCPC108.AMER.DELL.COM>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 01:36:56PM -0500, Rezwanul_Kabir@Dell.com wrote:
> Hi Islam Amer
> 
>    I got report that "Ubuntu 10.04 + BIOS A11" was tested and the "Eject CD" key is working
>    as expected. Sorry, I couldn't find any Studio 1555 to test myself and cannot provide you
>    with more details. 
> 
>     Also, you may try acpi_osi="Windows 2009" kernel parameter and see if there is any difference.

That's the default on any kernel that has this support in dell-wmi. Rez, 
could you let me know if the proposed patch breaks the spec in ways that 
are likely to cause problems?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
