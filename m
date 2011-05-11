Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab1EKRLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:11:36 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:37354 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab1EKRLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:11:34 -0400
X-Greylist: delayed 4199 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 13:11:34 EDT
From: Ian Campbell <ijc@hellion.org.uk>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Allen Kay <allen.m.kay@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1103161610110.3382@kaball-desktop>
References: <alpine.DEB.2.00.1102281605130.2917@kaball-desktop>
	 <20110304104251.45b257c4@jbarnes-desktop>
	 <1299595858.17339.512.camel@zakaz.uk.xensource.com>
	 <1299601032.17339.525.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.00.1103161230570.3382@kaball-desktop>
	 <20110316083205.405910ac@jbarnes-desktop>
	 <alpine.DEB.2.00.1103161610110.3382@kaball-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 14:33:38 +0100
Message-ID: <1305120818.26692.394.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [Xen-devel] Re: [RFC PATCH] set current_state to D0 in
 register_slot
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

On Wed, 2011-03-16 at 16:13 +0000, Stefano Stabellini wrote:
> On Wed, 16 Mar 2011, Jesse Barnes wrote:
> > On Wed, 16 Mar 2011 12:34:10 +0000
> > Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > 
> > > Jesse,
> > > do you have any comments on the following patch?
> > > Also, are you OK with taking "set current_state to D0 in register_slot"
> > > in your tree? Otherwise should I send a pull request to Linus with the
> > > patch and your ack?
> > 
> > Yeah, I think the patch is ok, I can send it to Linus either as part of
> > my 2.6.39 pull req (though it's probably too late for that) or in my
> > next -fixes pull.
> 
> Great, thanks!
> 
> Just to be clear there are two different patches, the first one is "set
> current_state to D0 in register_slot":
> 
> https://lkml.org/lkml/2011/2/28/296
> 
> the second one by Ian Campbell is "acpiphp: assume device is in state D0
> after powering on a slot.":
> 
> https://lkml.org/lkml/2011/3/8/212

Looks like the first of these is in your tree but not the second. Do you
want me to resend and/or rework it?

Ian.

-- 
Ian Campbell
Current Noise: Anathema - Dreaming Light

I never met a woman I couldn't drink pretty.

