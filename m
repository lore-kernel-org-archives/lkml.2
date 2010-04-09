Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab0DIWji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:39:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50932 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754295Ab0DIWjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:39:35 -0400
Date: Fri, 9 Apr 2010 23:42:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: guenter.roeck@ericsson.com, linux-kernel@vger.kernel.org,
       Yinghai <yinghai.lu@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>, Andy Isaacson <adi@hexapodia.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well as
 x86_32
Message-ID: <20100409234245.4081994a@lxorguk.ukuu.org.uk>
In-Reply-To: <4BBF91C6.9090701@zytor.com>
References: <20100407210628.28364.96982.stgit@bob.kio>
	<201004071705.07176.bjorn.helgaas@hp.com>
	<4BBD13C3.2060404@oracle.com>
	<201004091004.39857.bjorn.helgaas@hp.com>
	<4BBF5987.3010100@zytor.com>
	<4BBF626A.3060800@oracle.com>
	<4BBF70BC.3080809@zytor.com>
	<1270839357.1477.758.camel@groeck-laptop>
	<4BBF89FE.5040909@zytor.com>
	<1270845108.1477.784.camel@groeck-laptop>
	<4BBF91C6.9090701@zytor.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "Don't use legacy fixed-function addresses for nonstandard purposes."
> 
> There, there is your documentation.

It's probably a good idea to only reserve it if the space is actually
being used. There are a variety of legitimate reasons to use that space
for other things on embedded x86 boards.

They are only "legacy fixed function" if you have a PCI bus...
