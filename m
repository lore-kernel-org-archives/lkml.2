Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab2GTLKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 07:10:46 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:29313 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2GTLKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 07:10:44 -0400
X-IronPort-AV: E=Sophos;i="4.77,622,1336348800"; 
   d="scan'208";a="13624815"
Date: Fri, 20 Jul 2012 12:09:56 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>
Subject: Re: [PATCH WIP 6/6] xen/arm: enable evtchn irqs
In-Reply-To: <20120719233045.GA944@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1207201208230.23783@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com> <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com> <1340381685-22529-6-git-send-email-stefano.stabellini@eu.citrix.com> <20120709144005.GA12102@phenom.dumpdata.com>
 <alpine.DEB.2.02.1207131749470.23783@kaball.uk.xensource.com> <20120716145709.GB552@phenom.dumpdata.com> <alpine.DEB.2.02.1207181750500.23783@kaball.uk.xensource.com> <20120719233045.GA944@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > > OK, please include those questions/answers in the git commit and
> > > repost.
> 
> I seem to be missing the rest of the patches. I see the drivers/xen/events also
> has the  xen_init_IRQ_arm... is there a git tree with the base patches?

Yes, the latest git tree, based on
55b02d2f4445ad625213817a1736bf2884d32547, is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git xenarmv7-3
