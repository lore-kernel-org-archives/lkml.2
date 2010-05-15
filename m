Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0EOCZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 22:25:49 -0400
Received: from relay3.sgi.com ([192.48.152.1]:39924 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753272Ab0EOCZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 22:25:47 -0400
Message-ID: <4BEE0623.9010801@sgi.com>
Date: Fri, 14 May 2010 19:25:39 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Mike Habeck <habeck@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Jacob Pan <jacob.jun.pan@intel.com>,
       Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai <yinghai.lu@oracle.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Myron Stowe <myron.stowe@hp.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com>	<201005131256.17997.bjorn.helgaas@hp.com>	<4BEC5530.1000008@sgi.com>	<201005131402.30759.bjorn.helgaas@hp.com> <20100514152509.3aeb37b4@virtuousgeek.org> <4BEDCFD9.7020202@sgi.com> <4BEDD03B.30106@zytor.com> <4BEDD14A.1030400@sgi.com>
In-Reply-To: <4BEDD14A.1030400@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... We're somewhat fortunate in that our Legacy I/O
> devices are confined to those on the first blade, and all of these
> other devices are on other blades (PCI segments 1+).


By "somewhat" I meant we'd be way more fortunate without the
legacy I/O devices at all!  But hpa is right, 4 lines of
assembler is way better than (900?) lines of C.

My feeling is that if a CPU needs legacy i/o it should be
built into the chip.  HAH!  ;-)

The BIOS should just list the machine resources, in a
"non-BIOS" way, (oh wait, that's ACPI! :*)

Cheers!
