Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab1DMKYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:24:36 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:51135 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab1DMKYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:24:35 -0400
X-IronPort-AV: E=Sophos;i="4.64,203,1301875200"; 
   d="scan'208";a="5280562"
Date: Wed, 13 Apr 2011 11:24:47 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 1/4] xen: mask_rw_pte mark RO all pagetable pages up to
 pgt_buf_top
In-Reply-To: <20110412164745.GB1067@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1104131124360.22672@kaball-desktop>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop> <1302607192-21355-1-git-send-email-stefano.stabellini@eu.citrix.com> <20110412164745.GB1067@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011, Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 12, 2011 at 12:19:49PM +0100, stefano.stabellini@eu.citrix.com wrote:
> > From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > mask_rw_pte is currently checking if a pfn is a pagetable page if it
> > falls in the range pgt_buf_start - pgt_buf_end but that is incorrect
> > because pgt_buf_end is a moving target: pgt_buf_top is the real
> > boundary.
> 
> OK. Stuck it on the queue for rc3.

great, thanks.
