Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab0ENUpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:45:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948Ab0ENUpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:45:52 -0400
Date: Thu, 13 May 2010 19:54:31 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, chrisw@redhat.com
Subject: Re: [PATCH] kvm: remove CAP_SYS_RAWIO requirement from
 kvm_vm_ioctl_assign_irq
Message-ID: <20100513225431.GE27620@amt.cnet>
References: <20100512134619.30602.63792.stgit@virtlab9.virt.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512134619.30602.63792.stgit@virtlab9.virt.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 09:46:31AM -0400, Alex Williamson wrote:
> Remove this check in an effort to allow kvm guests to run without
> root privileges.  This capability check doesn't seem to add any
> security since the device needs to have already been added via the
> assign device ioctl and the io actually occurs through the pci
> sysfs interface.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Applied, thanks.

