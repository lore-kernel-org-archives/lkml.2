Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab1JXJnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:43:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab1JXJnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:43:03 -0400
Date: Mon, 24 Oct 2011 11:38:29 +0200
From: Greg KH <gregkh@suse.de>
To: Raghavendra K T <raghukt@linux.vnet.ibm.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Xen <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 2/5] debugfs: Renaming of xen functions and change
 unsigned to u32
Message-ID: <20111024093829.GA2214@suse.de>
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com>
 <20111023190459.16364.98151.sendpatchset@oc5400248562.ibm.com>
 <20111023221920.GA591@suse.de>
 <4EA52FCF.2090508@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA52FCF.2090508@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 02:58:47PM +0530, Raghavendra K T wrote:
> On 10/24/2011 03:49 AM, Greg KH wrote:
> >On Mon, Oct 24, 2011 at 12:34:59AM +0530, Raghavendra K T wrote:
> >>Renaming of xen functions and change unsigned to u32.
> >
> >Why not just rename when you move the functions?  Why the extra step?
> >
> Intention was only clarity. Yes, if this patch is an overhead, I 'll
> combine both the patches.

Yeah, it makes more sense as it originally confused me why you were
adding a "xen_*" function to the debugfs core code :)

thanks,

greg k-h
