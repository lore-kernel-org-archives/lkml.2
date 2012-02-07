Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab2BGLsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 06:48:24 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:46803 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641Ab2BGLsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 06:48:23 -0500
Date: Tue, 7 Feb 2012 12:48:06 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org
Subject: Re: Linux 3.2.5
Message-ID: <20120207114806.GA15323@citd.de>
References: <20120206181622.GA28811@kroah.com>
 <20120207084037.GA6140@citd.de>
 <4F30FABF.4060409@ladisch.de>
 <20120207105835.GA12864@citd.de>
 <4F310DBC.1040501@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F310DBC.1040501@ladisch.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.02.2012 12:40, Clemens Ladisch wrote:
> Matthias Schniedermeyer wrote:
> > On 07.02.2012 11:19, Clemens Ladisch wrote:
> >> Matthias Schniedermeyer wrote:
> >>> pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> >>
> >> Please try that kernel parameter.
> >
> > I don't want/need ASPM, disabled is fine with me.
> 
> In your case, it appears that sound requires ASPM.

OK. I will try that later today.

But i'm not hopeful because in syslog it says:
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
...
ACPI _OSC control for PCIe not granted, disabling ASPM

So if ACPI doesn't want to relinquish control of ASPM, how is Linux 
supposed to enable it?





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

