Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab2GLJBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 05:01:46 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:15966 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab2GLJBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 05:01:44 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFGjS0PFkFT
X-RZG-CLASS-ID: mo00
Date: Thu, 12 Jul 2012 11:01:42 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH] xen pv-on-hvm: add pfn_is_ram helper for kdump
Message-ID: <20120712090142.GA15563@aepfle.de>
References: <1342083605-15371-1-git-send-email-olaf@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1342083605-15371-1-git-send-email-olaf@aepfle.de>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, Olaf Hering wrote:

> +	if (HYPERVISOR_hvm_op(HVMOP_get_mem_type, &a))
> +		return -ENXIO;
> +
> +	switch (a.mem_type) {
> +		case HVMMEM_mmio_dm:


Sorry, this commit misses the required hypercall defines.
I will fix it up and resend.

Olaf
