Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab0DIVAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 17:00:13 -0400
Received: from imr2.ericy.com ([198.24.6.3]:51612 "EHLO imr2.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab0DIVAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 17:00:10 -0400
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
 as x86_32
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
CC: Yinghai <yinghai.lu@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>, Andy Isaacson <adi@hexapodia.org>,
       Thomas Renninger <trenn@suse.de>
In-Reply-To: <4BBF91C6.9090701@zytor.com>
References: <20100407210628.28364.96982.stgit@bob.kio>
	 <201004071705.07176.bjorn.helgaas@hp.com> <4BBD13C3.2060404@oracle.com>
	 <201004091004.39857.bjorn.helgaas@hp.com> <4BBF5987.3010100@zytor.com>
	 <4BBF626A.3060800@oracle.com>  <4BBF70BC.3080809@zytor.com>
	 <1270839357.1477.758.camel@groeck-laptop>  <4BBF89FE.5040909@zytor.com>
	 <1270845108.1477.784.camel@groeck-laptop>  <4BBF91C6.9090701@zytor.com>
Content-Type: text/plain
Organization: Ericsson
Date: Fri, 9 Apr 2010 14:01:02 -0700
Message-ID: <1270846862.1477.788.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 16:44 -0400, H. Peter Anvin wrote:
> On 04/09/2010 01:31 PM, Guenter Roeck wrote:
> > 
> > It is used for a custom FPGA implementing a watchdog timer and some
> > other functionality.
> > 
> > This is not a matter of supporting such a device in Linux, it is a
> > matter of explicitly excluding non-VGA devices from using VGA memory
> > space.
> > 
> > If that is the decision, it might be worthwhile mentioning it somewhere
> > in the documentation, to prevent others from ever using that memory
> > space in an embedded system (and to save them the time needed to find
> > out about it and to identify and implement a workaround).
> > 
> 
> "Don't use legacy fixed-function addresses for nonstandard purposes."
> 
> There, there is your documentation.

Fair and good enough, as long as it is going to show up somewhere.

Guenter


