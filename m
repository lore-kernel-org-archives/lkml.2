Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1EKPoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:44:10 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:44674 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754546Ab1EKPoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:44:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bsf5E42v+FhKBk/pyJxMWpxECYDl03Sbra0huR/ArJ4Xzy51ustDoH55Nn7c878dKo5YPwEB7BxRDBydvw2a74Q7/eFa4EZ0l/ZBcghXoFDyIvCKMecd0E8+41Y62NdB;
Date: Wed, 11 May 2011 08:43:54 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Allen Kay <allen.m.kay@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [RFC PATCH] set current_state to D0 in
 register_slot
Message-ID: <20110511084354.49eee757@jbarnes-desktop>
In-Reply-To: <1305120818.26692.394.camel@zakaz.uk.xensource.com>
References: <alpine.DEB.2.00.1102281605130.2917@kaball-desktop>
	<20110304104251.45b257c4@jbarnes-desktop>
	<1299595858.17339.512.camel@zakaz.uk.xensource.com>
	<1299601032.17339.525.camel@zakaz.uk.xensource.com>
	<alpine.DEB.2.00.1103161230570.3382@kaball-desktop>
	<20110316083205.405910ac@jbarnes-desktop>
	<alpine.DEB.2.00.1103161610110.3382@kaball-desktop>
	<1305120818.26692.394.camel@zakaz.uk.xensource.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 14:33:38 +0100
Ian Campbell <ijc@hellion.org.uk> wrote:

> Hi Jesse,
> 
> On Wed, 2011-03-16 at 16:13 +0000, Stefano Stabellini wrote:
> > On Wed, 16 Mar 2011, Jesse Barnes wrote:
> > > On Wed, 16 Mar 2011 12:34:10 +0000
> > > Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > > 
> > > > Jesse,
> > > > do you have any comments on the following patch?
> > > > Also, are you OK with taking "set current_state to D0 in register_slot"
> > > > in your tree? Otherwise should I send a pull request to Linus with the
> > > > patch and your ack?
> > > 
> > > Yeah, I think the patch is ok, I can send it to Linus either as part of
> > > my 2.6.39 pull req (though it's probably too late for that) or in my
> > > next -fixes pull.
> > 
> > Great, thanks!
> > 
> > Just to be clear there are two different patches, the first one is "set
> > current_state to D0 in register_slot":
> > 
> > https://lkml.org/lkml/2011/2/28/296
> > 
> > the second one by Ian Campbell is "acpiphp: assume device is in state D0
> > after powering on a slot.":
> > 
> > https://lkml.org/lkml/2011/3/8/212
> 
> Looks like the first of these is in your tree but not the second. Do you
> want me to resend and/or rework it?

Yeah, please re-send it, I confused the two and thought Stefano's was
sufficient.

-- 
Jesse Barnes, Intel Open Source Technology Center
