Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab0E1RKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:10:24 -0400
Received: from relay3.sgi.com ([192.48.152.1]:54956 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758916Ab0E1RKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:10:23 -0400
Message-ID: <4BFFF8F8.1070502@sgi.com>
Date: Fri, 28 May 2010 10:10:16 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       Mike Habeck <habeck@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com> <4BFFF517.6040401@sgi.com> <4BFFF6B8.30005@zytor.com>
In-Reply-To: <4BFFF6B8.30005@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



H. Peter Anvin wrote:
> On 05/28/2010 09:53 AM, Mike Travis wrote:
>> Any further consideration for this patch, or has it been rejected?
> 
> Well, it's really up to Jesse, but as far as I can see, this patch is a
> net loss of functionality and doesn't actually add anything.  Without
> this patch, some resources that were not assigned by BIOS will be
> unreachable.  With this patch, *all* resources that were not assigned by
> BIOS will be unreachable...
> 
> 	-hpa
> 

Apparently you're missing the point of the patch?  The patch is needed
because BIOS is purposely not assigning I/O BAR's to devices that won't
use them, freeing up the resource for devices that do need them.  Where
is the "all" resources that are not reachable?

Thanks,
Mike
