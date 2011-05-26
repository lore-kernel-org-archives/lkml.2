Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab1EZRcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:32:08 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:46829 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab1EZRcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:32:07 -0400
Date: Thu, 26 May 2011 23:01:56 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com
Subject: Re: [RFC Patch 0/6] slimdump: Enable slimdump if crashing kernel
 memory is not required
Message-ID: <20110526173156.GC18295@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20110526170722.GB23266@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526170722.GB23266@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 10:37:22PM +0530, K.Prasad wrote:
> Hi All,

A small correction related to patch description...

> 
> Summary of the patches
> ----
> Patch 1, 2 - Patches from Andi Kleen's tree
> git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git which
> introduce an enhanced panic function - xpanic().
> 

Patch 3 - A small bugfix for patch 1,2

Patch 4 - Introduces a new PANIC_MCE flag to signal the need for slimdump
for MCE initiated panic calls. Appends a new elf-note inside coredump
containing MCE related registers.

Thanks,
K.Prasad

