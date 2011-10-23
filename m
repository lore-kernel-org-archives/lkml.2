Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab1JWWXJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 18:23:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab1JWWXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 18:23:05 -0400
Date: Mon, 24 Oct 2011 00:20:12 +0200
From: Greg KH <gregkh@suse.de>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Virtualization <virtualization@lists.linux-foundation.org>,
        Gleb Natapov <gleb@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        KVM <kvm@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        Xen <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 1/5] debugfs: Add support to print u32 array in
 debugfs
Message-ID: <20111023222012.GB591@suse.de>
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com>
 <20111023190403.16364.30897.sendpatchset@oc5400248562.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111023190403.16364.30897.sendpatchset@oc5400248562.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 12:34:04AM +0530, Raghavendra K T wrote:
> Add debugfs support to print u32-arrays in debugfs. Move the code from Xen to debugfs
> to make the code common for other users as well.

You forgot the kerneldoc for the function explaining what it is and how
to use it, and the EXPORT_SYMBOL_GPL() marking for the global function
as that's the only way it will be able to be used, right?

thanks,

greg k-h
