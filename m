Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab1CPQOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 12:14:35 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:9604 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1CPQO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 12:14:28 -0400
X-IronPort-AV: E=Sophos;i="4.63,195,1299456000"; 
   d="scan'208";a="4823513"
Date: Wed, 16 Mar 2011 16:13:57 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ijc@hellion.org.uk>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Allen Kay <allen.m.kay@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [RFC PATCH] set current_state to D0 in
 register_slot
In-Reply-To: <20110316083205.405910ac@jbarnes-desktop>
Message-ID: <alpine.DEB.2.00.1103161610110.3382@kaball-desktop>
References: <alpine.DEB.2.00.1102281605130.2917@kaball-desktop> <20110304104251.45b257c4@jbarnes-desktop> <1299595858.17339.512.camel@zakaz.uk.xensource.com> <1299601032.17339.525.camel@zakaz.uk.xensource.com> <alpine.DEB.2.00.1103161230570.3382@kaball-desktop>
 <20110316083205.405910ac@jbarnes-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011, Jesse Barnes wrote:
> On Wed, 16 Mar 2011 12:34:10 +0000
> Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> 
> > Jesse,
> > do you have any comments on the following patch?
> > Also, are you OK with taking "set current_state to D0 in register_slot"
> > in your tree? Otherwise should I send a pull request to Linus with the
> > patch and your ack?
> 
> Yeah, I think the patch is ok, I can send it to Linus either as part of
> my 2.6.39 pull req (though it's probably too late for that) or in my
> next -fixes pull.

Great, thanks!

Just to be clear there are two different patches, the first one is "set
current_state to D0 in register_slot":

https://lkml.org/lkml/2011/2/28/296

the second one by Ian Campbell is "acpiphp: assume device is in state D0
after powering on a slot.":

https://lkml.org/lkml/2011/3/8/212
