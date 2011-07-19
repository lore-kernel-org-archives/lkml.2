Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab1GSPqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 11:46:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab1GSPqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 11:46:34 -0400
Date: Tue, 19 Jul 2011 11:43:04 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, chrisw@redhat.com,
        ddutile@redhat.com, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] kvm: Disable device assignment without interrupt
 remapping
Message-ID: <20110719144304.GA31520@amt.cnet>
References: <20110714192500.4065.28234.stgit@s20.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714192500.4065.28234.stgit@s20.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 01:27:03PM -0600, Alex Williamson wrote:
> IOMMU interrupt remapping support provides a further layer of
> isolation for device assignment by preventing arbitrary interrupt
> block DMA writes by a malicious guest from reaching the host.  By
> default, we should require that the platform provides interrupt
> remapping support, with an opt-in mechanism for existing behavior.
> 
> Both AMD IOMMU and Intel VT-d2 hardware support interrupt
> remapping, however we currently only have software support on
> the Intel side.  Users wishing to re-enable device assignment
> when interrupt remapping is not supported on the platform can
> use the "allow_unsafe_assigned_interrupts=1" module option.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Applied, thanks.

