Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab2GCBlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:41:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563Ab2GCBli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:41:38 -0400
Date: Mon, 2 Jul 2012 21:10:44 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, mst@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com, cornelia.huck@de.ibm.com
Subject: Re: [PATCH v3 0/3] kvm: KVM_IRQFD cleanup, docs, sanitize flags
Message-ID: <20120703001044.GA7518@amt.cnet>
References: <20120629154940.30535.17132.stgit@bling.home>
 <1341244311.1207.449.camel@bling.home>
 <4FF1C3CE.3020404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF1C3CE.3020404@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 06:52:46PM +0300, Avi Kivity wrote:
> On 07/02/2012 06:51 PM, Alex Williamson wrote:
> > On Fri, 2012-06-29 at 09:56 -0600, Alex Williamson wrote:
> >> Before we start fiddling with what we can and can't add to KVM_IRQFD
> >> we need to figure out if anyone has been sloppy in their use of the
> >> ioctl flags.  This series has a minor cleanup to pass the struct
> >> kvm_irqfd to seup functions rather than individual parameters, making
> >> it more consistent with ioeventfd, adds API documentation for this
> >> ioctl, and sanitizes the flags.  If anyone screams, we may have to
> >> revert this last patch.  Thanks,
> > 
> > Avi, what do you think about trying to get this in for 3.5 to test
> > whether we break anyone?  Then we can aim for 3.6 for level irqfd &
> > eoifd support.
> 
> Makes sense.  Marcelo?

Applied to master, thanks.

