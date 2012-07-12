Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161521Ab2GLRo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:44:26 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:36634 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161495Ab2GLRoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:44:23 -0400
X-IronPort-AV: E=Sophos;i="4.77,575,1336348800"; 
   d="scan'208";a="13508697"
Date: Thu, 12 Jul 2012 18:43:43 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Tim (Xen.org)" <tim@xen.org>, Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [PATCH WIP 3/6] xen/arm: get privilege status
In-Reply-To: <20120709144129.GB12102@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1207121840230.23783@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com> <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com> <1340381685-22529-3-git-send-email-stefano.stabellini@eu.citrix.com> <20120709144129.GB12102@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, Konrad Rzeszutek Wilk wrote:
> On Fri, Jun 22, 2012 at 05:14:42PM +0100, Stefano Stabellini wrote:
> > Use Xen features to figure out if we are privileged.
> 
> Is there a corresponding Xen c/s for the XNEFEAT_dom0?

Yes, that would be 23735
(http://xenbits.xensource.com/hg/xen-unstable.hg/rev/537918f518ee).

> Why can't the existing SIF_PRIVILIGED call work? Isn't that
> somethign that the hypervisor sets for the guest?

SIF_PRIVILIGED is in the start_info page that ARM guests don't have.
