Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab2C0R73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 13:59:29 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:43902 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab2C0R72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 13:59:28 -0400
Date: Tue, 27 Mar 2012 13:59:21 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/2] m2p_find_override: use list_for_each_entry_safe
Message-ID: <20120327175921.GB4299@andromeda.dapyr.net>
References: <1332856364-29995-1-git-send-email-stefano.stabellini@eu.citrix.com> <1332856364-29995-2-git-send-email-stefano.stabellini@eu.citrix.com> <20120327142654.GA30655@phenom.dumpdata.com> <alpine.DEB.2.00.1203271733370.15151@kaball-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.1203271733370.15151@kaball-desktop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 05:37:07PM +0100, Stefano Stabellini wrote:
> On Tue, 27 Mar 2012, Konrad Rzeszutek Wilk wrote:
> > On Tue, Mar 27, 2012 at 02:52:44PM +0100, Stefano Stabellini wrote:
> > > Use list_for_each_entry_safe and remove the spin_lock acquisition in
> > > m2p_find_override.
> > 
> > So this would allow us to get stale entries. Is that OK?
> 
> I think it is reasonable.
> In practice we should never get an m2p_find_override call looking for an
> entry that we are about to add/delete.

Why don't you add that in the comment and also fix:

/home/konrad/ssd/linux/arch/x86/xen/p2m.c: In function
‘m2p_find_override’:
/home/konrad/ssd/linux/arch/x86/xen/p2m.c:810: warning: unused variable
‘flags’


> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
