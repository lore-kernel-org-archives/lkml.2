Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab0DUTbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 15:31:23 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:46518 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab0DUTbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:31:20 -0400
Date: Wed, 21 Apr 2010 12:31:20 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH -v4 1/3] x86: Reserve [0xa0000, 0x100000] in e820 map
Message-ID: <20100421193120.GD11130@hexapodia.org>
References: <4BC4E55B.7000103@oracle.com> <4BC4E8FB.8060802@zytor.com> <4BC4F03C.1020707@oracle.com> <4BC4F320.8020902@zytor.com> <4BC4F703.5030700@oracle.com> <4BC4F80C.2020209@zytor.com> <4BC4F851.7040500@oracle.com> <4BC4F948.8050500@zytor.com> <4BC4F9C2.20503@oracle.com> <4BCE8E3E.4030809@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCE8E3E.4030809@oracle.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 10:33:50PM -0700, Yinghai wrote:
> Update e820 at first, and later put them resource tree.
> Reserved that early, will not be allocated to unassigned PCI BAR
> 
> v3: remove probe_roms() that is not needed, because whole range is reserved
> 	 already

Test booted this patch series on the problematic t3400, seems to work
fine.  dmesg attached to bug 15744.

-andy
