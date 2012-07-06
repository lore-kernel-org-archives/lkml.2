Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab2GFLcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:32:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab2GFLcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:32:17 -0400
Date: Fri, 6 Jul 2012 08:27:19 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] kvm, Add x86_hyper_kvm to complete
 detect_hypervisor_platform check [v2]
Message-ID: <20120706112719.GA18059@amt.cnet>
References: <1341493877-16622-1-git-send-email-prarit@redhat.com>
 <1341493877-16622-2-git-send-email-prarit@redhat.com>
 <4FF59606.4060504@redhat.com>
 <4FF5987C.6080905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF5987C.6080905@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 09:37:00AM -0400, Prarit Bhargava wrote:
> 
> 
> On 07/05/2012 09:26 AM, Avi Kivity wrote:
> > Please copy at least kvm@vger.kernel.org, and preferably Marcelo as well
> > (the other kvm co-maintainer).
> > 
> > 
> 
> While debugging I noticed that unlike all the other hypervisor code in the
> kernel, kvm does not have an entry for x86_hyper which is used in
> detect_hypervisor_platform() which results in a nice printk in the
> syslog.  This is only really a stub function but it
> does make kvm more consistent with the other hypervisors.
> 
> [v2]: add detect and _GPL export
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Looks good, please regenerate:

Hunk #1 FAILED at 39.
Hunk #2 succeeded at 484 (offset 51 lines).
1 out of 2 hunks FAILED -- saving rejects to file
arch/x86/kernel/kvm.c.rej


