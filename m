Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab2JQQkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:40:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51470 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757387Ab2JQQkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:40:08 -0400
Date: Wed, 17 Oct 2012 18:40:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, gong.chen@linux.intel.com, ananth@in.ibm.com,
        masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, bp@amd64.org, lcm@us.ibm.com,
        andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, gregkh@suse.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH v3] x86/mce: Honour bios-set CMCI threshold
Message-ID: <20121017164006.GA14596@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
	tony.luck@intel.com, gong.chen@linux.intel.com, ananth@in.ibm.com,
	masbock@linux.vnet.ibm.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, bp@amd64.org, lcm@us.ibm.com,
	andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
	mingo@redhat.com, gregkh@suse.de, linux-edac@vger.kernel.org
References: <CA+8MBbKVa0=qUpG-rjV5ieKkponZo77mzk_y_dF4qA2gVG++6A@mail.gmail.com>
 <20120912122516.3825.87838.stgit@localhost.localdomain>
 <505C51D8.6070402@linux.vnet.ibm.com>
 <20121017105940.GA14590@x1.osrc.amd.com>
 <507E9622.6090606@linux.vnet.ibm.com>
 <20121017130934.GB14590@x1.osrc.amd.com>
 <507ED31B.7010402@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <507ED31B.7010402@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 09:17:39PM +0530, Naveen N. Rao wrote:
> Userspace tools need this sysfs attribute so they know how to react on
> receipt of a corrected error event: whether this is the first event or
> if such events have already been threshold-ed.

What's wrong with userspace tools parsing /proc/cmdline and seeing that
mce_bios_cmci_threshold has been set since this is the only way to set
it anyway?

I still don't see any reason for that read-only sysfs attribute.

Thanks.

-- 
Regards/Gruss,
Boris.
