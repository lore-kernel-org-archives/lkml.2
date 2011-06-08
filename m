Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1FHVbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:31:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:56294 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab1FHVbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:31:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,339,1304319600"; 
   d="scan'208";a="9486448"
Message-ID: <4DEFEA3A.5050604@linux.intel.com>
Date: Wed, 08 Jun 2011 14:31:38 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <20110608193833.GA29855@srcf.ucam.org> <4DEFD220.5040507@kernel.org> <20110608195250.GB30256@srcf.ucam.org> <4DEFD58D.5060402@kernel.org> <20110608200903.GA30694@srcf.ucam.org> <4DEFDA4A.9080500@kernel.org> <20110608203037.GA31052@srcf.ucam.org> <4DEFDD69.7010000@kernel.org> <20110608204244.GA31484@srcf.ucam.org> <BANLkTikfbSsgGgNEQ3GVD=HOPn1Dz_xh+g@mail.gmail.com> <20110608212813.GB32056@srcf.ucam.org>
In-Reply-To: <20110608212813.GB32056@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 02:28 PM, Matthew Garrett wrote:
> 
> E820 limits us to 128 ranges, and systems I'm looking at right now are 
> already using over 140 boot services regions. Some of them are 
> contiguous and we could just merge them for e820, but that leaves us at 
> the whim of whoever wrote the allocator for the firmware. And do you 
> want to bet on them having done this sanely?
> 

No, we're not limited to 128.  We're limited to 128 in the boot
structure, but more can be passed via the linked list.

	-hpa
