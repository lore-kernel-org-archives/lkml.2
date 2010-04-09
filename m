Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab0DIWVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:21:08 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:51302 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab0DIWVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:21:05 -0400
Date: Fri, 9 Apr 2010 15:21:03 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: guenter.roeck@ericsson.com, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
	as x86_32
Message-ID: <20100409222103.GA11130@hexapodia.org>
References: <20100407210628.28364.96982.stgit@bob.kio> <201004071705.07176.bjorn.helgaas@hp.com> <4BBD13C3.2060404@oracle.com> <201004091004.39857.bjorn.helgaas@hp.com> <4BBF5987.3010100@zytor.com> <4BBF626A.3060800@oracle.com> <4BBF70BC.3080809@zytor.com> <1270839357.1477.758.camel@groeck-laptop> <4BBF863B.1060806@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBF863B.1060806@oracle.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 12:55:39PM -0700, Yinghai wrote:
> update version for test
> 
> Subject: [PATCH] x86: reserve [0xa0000, 0x100000] in e820
> 
> Update e820 at first, and later put them resource tree.
> But give pci BAR chance to claim the range, before assign unassigned resources.
> 
> In case some system doesn't have VGA, and use [0xa0000, ..] for mmio of some
> other pci devices.

This doesn't help, my AHCI still fails to initialize in the same way.

-andy
