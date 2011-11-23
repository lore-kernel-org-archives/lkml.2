Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab1KWBai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:30:38 -0500
Received: from ozlabs.org ([203.10.76.45]:46853 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab1KWBah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:30:37 -0500
Date: Wed, 23 Nov 2011 12:15:17 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tanmay Inamdar <tinamdar@apm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: powerpc: dts: Fix canyonlands EMAC interrupt map
Message-ID: <20111123011517.GA5183@truffala.fritz.box>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Tanmay Inamdar <tinamdar@apm.com>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
References: <1321945877-22802-1-git-send-email-tinamdar@apm.com>
 <1321996600.14573.0.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321996600.14573.0.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 08:16:40AM +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2011-11-22 at 12:41 +0530, Tanmay Inamdar wrote:
> > Fixing interrupt mapping of EMAC for canyonlands
> 
> The previous stuff was odd .... but was it broken ?
> 
> It was done this way because the EMAC actually has more interrupts than
> that which are routed to different UICs, and so doing a local map this
> way allows to target multiple parents.

Well, in the canyonlands case, it appears that the interrupts went to
the same pic, so the simpler representation should be correct as
well.  However, there certainly are boards where they go to multiple
pics, so we need this interrupt-map trick.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
