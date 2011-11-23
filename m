Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab1KWBnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:43:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:42406 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab1KWBnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:43:19 -0500
Message-ID: <1322012538.14573.20.camel@pasglop>
Subject: Re: powerpc: dts: Fix canyonlands EMAC interrupt map
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Tanmay Inamdar <tinamdar@apm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Wed, 23 Nov 2011 12:42:18 +1100
In-Reply-To: <20111123011517.GA5183@truffala.fritz.box>
References: <1321945877-22802-1-git-send-email-tinamdar@apm.com>
	 <1321996600.14573.0.camel@pasglop>
	 <20111123011517.GA5183@truffala.fritz.box>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 12:15 +1100, David Gibson wrote:
> On Wed, Nov 23, 2011 at 08:16:40AM +1100, Benjamin Herrenschmidt wrote:
> > On Tue, 2011-11-22 at 12:41 +0530, Tanmay Inamdar wrote:
> > > Fixing interrupt mapping of EMAC for canyonlands
> > 
> > The previous stuff was odd .... but was it broken ?
> > 
> > It was done this way because the EMAC actually has more interrupts than
> > that which are routed to different UICs, and so doing a local map this
> > way allows to target multiple parents.
> 
> Well, in the canyonlands case, it appears that the interrupts went to
> the same pic, so the simpler representation should be correct as
> well.  However, there certainly are boards where they go to multiple
> pics, so we need this interrupt-map trick.

Doesn't emac has something like 4 more interrupts that we simply haven't
been bothered wiring up (because we don't use them ?)

Cheers,
Ben.


