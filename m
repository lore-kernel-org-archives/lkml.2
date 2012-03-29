Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418Ab2C2OBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 10:01:51 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:28907 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759101Ab2C2OBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 10:01:45 -0400
X-IronPort-AV: E=Sophos;i="4.75,337,1330905600"; 
   d="scan'208";a="11643907"
Date: Thu, 29 Mar 2012 15:03:04 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/2] m2p_find_override: use
 list_for_each_entry_safe
In-Reply-To: <20120327175921.GB4299@andromeda.dapyr.net>
Message-ID: <alpine.DEB.2.00.1203291502460.15151@kaball-desktop>
References: <1332856364-29995-1-git-send-email-stefano.stabellini@eu.citrix.com> <1332856364-29995-2-git-send-email-stefano.stabellini@eu.citrix.com> <20120327142654.GA30655@phenom.dumpdata.com> <alpine.DEB.2.00.1203271733370.15151@kaball-desktop>
 <20120327175921.GB4299@andromeda.dapyr.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="8323329-1317627345-1333029799=:15151"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8323329-1317627345-1333029799=:15151
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT

On Tue, 27 Mar 2012, Konrad Rzeszutek Wilk wrote:
> On Tue, Mar 27, 2012 at 05:37:07PM +0100, Stefano Stabellini wrote:
> > On Tue, 27 Mar 2012, Konrad Rzeszutek Wilk wrote:
> > > On Tue, Mar 27, 2012 at 02:52:44PM +0100, Stefano Stabellini wrote:
> > > > Use list_for_each_entry_safe and remove the spin_lock acquisition in
> > > > m2p_find_override.
> > > 
> > > So this would allow us to get stale entries. Is that OK?
> > 
> > I think it is reasonable.
> > In practice we should never get an m2p_find_override call looking for an
> > entry that we are about to add/delete.
> 
> Why don't you add that in the comment and also fix:
> 
> /home/konrad/ssd/linux/arch/x86/xen/p2m.c: In function
> ‘m2p_find_override’:
> /home/konrad/ssd/linux/arch/x86/xen/p2m.c:810: warning: unused variable
> ‘flags’

Ooops. I'll do that.
--8323329-1317627345-1333029799=:15151--
